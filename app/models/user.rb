class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :habits, dependent: :destroy
  has_many :completions, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :journal_entries, dependent: :destroy
  has_many :workouts, dependent: :destroy
  has_many :exercise_completions, dependent: :destroy
  has_many :schedule_items, dependent: :destroy
  has_many :penalties, dependent: :destroy
  has_one_attached :avatar

  validate :avatar_valido

  RANKS = { 1 => "E", 10 => "D", 20 => "C", 35 => "B", 50 => "A", 70 => "S" }.freeze
  RANK_TITLES = {
  "E" => "Caçador Novato",
  "D" => "Caçador Aprendiz",
  "C" => "Caçador Experiente",
  "B" => "Caçador de Elite",
  "A" => "Caçador Lendário",
  "S" => "Monarca"
  }.freeze
  POINTS_PER_LEVEL = 3
  ATTRIBUTE_LABELS = {
    "strength"     => "Força",
    "intelligence" => "Inteligência",
    "vitality"     => "Vitalidade",
    "discipline"   => "Disciplina"
  }.freeze
  LEVEL_UP_BONUS = 50
  TASK_XP_BASE = 50
  TASK_XP_STEP = 10
  TASK_XP_EVERY_LEVELS = 5
  PENALTY_RATE = 0.5
  MAX_PENALTY_CATCHUP_DAYS = 3

  def xp_to_next_level
    50 + 20 * level
  end

  def gain_xp!(amount)
    self.xp += amount
    self.coins += amount
    while xp >= xp_to_next_level
      self.xp -= xp_to_next_level
      self.level += 1
      self.coins += LEVEL_UP_BONUS
      self.attribute_points += POINTS_PER_LEVEL
    end
    self.rank = RANKS.select { |lvl, _| lvl <= level }.values.last
    save!
  end

  def buy!(reward)
    success = false
    transaction do
      lock!
      if coins >= reward.cost
        update!(coins: coins - reward.cost)
        purchases.create!(reward_name: reward.name, cost: reward.cost)
        success = true
      end
    end
    success
  end

  def current_streak
    dates = completions.select(:completed_on).distinct.order(completed_on: :desc).pluck(:completed_on)
    streak = 0
    day = Date.current
    day -= 1 if dates.first != day
    dates.each do |d|
      break unless d == day
      streak += 1
      day -= 1
    end
    streak
  end

  # Quanto da barra está preenchido (0 a 100).
  # Cada rank ocupa um trecho do mesmo tamanho, e dentro do trecho
  # a barra avança conforme o nível entre um rank e o próximo.
  def rank_progress_percent
    thresholds = RANKS.keys
    idx = thresholds.rindex { |min| level >= min } || 0
    return 100.0 if idx == thresholds.size - 1

    segment = 100.0 / (thresholds.size - 1)
    lo = thresholds[idx]
    hi = thresholds[idx + 1]
    (idx * segment + (level - lo).to_f / (hi - lo) * segment).round(1)
  end

  # [nível_mínimo, "Letra"] do próximo rank, ou nil se já está no máximo
  def next_rank
    RANKS.find { |min_level, _| min_level > level }
  end

  def spend_attribute_point!(attr)
  attr = attr.to_s
  return false unless ATTRIBUTE_LABELS.key?(attr)

    success = false
    with_lock do
      if attribute_points > 0
        self.attribute_points -= 1
        self[attr] += 1
        save!
        success = true
      end
    end
    success
  end

  def max_task_xp
    TASK_XP_BASE + (level / TASK_XP_EVERY_LEVELS) * TASK_XP_STEP
  end

  # Exercícios de treino têm um teto menor (60% do das missões)
  def max_exercise_xp
    (max_task_xp * 0.6).to_i
  end

  # Próximo nível em que o teto sobe
  def next_xp_cap_level
    (level / TASK_XP_EVERY_LEVELS + 1) * TASK_XP_EVERY_LEVELS
  end

  # Cobra as missões obrigatórias que ficaram sem fazer em dias anteriores.
  # Devolve a lista de penalidades aplicadas (vazia se não houve nenhuma).
  def settle_penalties!
    today = Date.current
    return [] if last_penalty_check && last_penalty_check >= today

    applied = []
    with_lock do
      if last_penalty_check.nil?
        update!(last_penalty_check: today)
      elsif last_penalty_check < today
        first_day = [ last_penalty_check, today - MAX_PENALTY_CATCHUP_DAYS ].max
        (first_day...today).each { |day| applied.concat(apply_penalties_for(day)) }
        update!(last_penalty_check: today)
      end
    end
    applied
  end

  private

  def avatar_valido
    return unless avatar.attached?

    unless avatar.content_type.in?(%w[image/png image/jpeg image/webp image/gif])
      errors.add(:avatar, "precisa ser PNG, JPG, WEBP ou GIF")
    end

    if avatar.byte_size > 2.megabytes
      errors.add(:avatar, "precisa ter no máximo 2 MB")
    end
  end

  def apply_penalties_for(day)
    done_ids = completions.where(completed_on: day).pluck(:habit_id)
    applied = []

    habits.active.where(mandatory: true).each do |habit|
      next if habit.created_at.to_date >= day
      next if done_ids.include?(habit.id)
      next if penalties.exists?(habit_id: habit.id, penalty_date: day)

      amount = habit.penalty_amount
      xp_lost = [ amount, xp ].min
      coins_lost = [ amount, coins ].min
      self.xp -= xp_lost
      self.coins -= coins_lost

      applied << penalties.create!(
        habit_id: habit.id, habit_name: habit.name, penalty_date: day,
        xp_lost: xp_lost, coins_lost: coins_lost
      )
    end

    save! if applied.any?
    applied
  end
end
