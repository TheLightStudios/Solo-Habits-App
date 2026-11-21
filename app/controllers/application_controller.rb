class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :settle_penalties

  private

  def settle_penalties
    return unless user_signed_in?

    applied = current_user.settle_penalties!
    return if applied.empty?

    names = applied.map(&:habit_name).uniq.join(", ")
    message = "[PENALIDADE] Missões obrigatórias não cumpridas: #{names}. " \
              "-#{applied.sum(&:xp_lost)} XP e -#{applied.sum(&:coins_lost)} moedas."

    target = request.get? ? flash.now : flash
    target[:penalty] = message
  end
end
