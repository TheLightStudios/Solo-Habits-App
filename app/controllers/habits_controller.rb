# app/controllers/habits_controller.rb
class HabitsController < ApplicationController
  before_action :set_habit, only: %i[edit update destroy]

  def index
    @habits = current_user.habits.active.order(:created_at)
    @done_ids = current_user.completions.where(completed_on: Date.current).pluck(:habit_id)
  end

  def new
    @habit = current_user.habits.build
  end

  def create
    @habit = current_user.habits.build(habit_params)
    if @habit.save
      redirect_to root_path, notice: "[SISTEMA] Nova missão registrada."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @habit.update(habit_params)
      redirect_to root_path, notice: "[SISTEMA] Missão atualizada."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @habit.destroy
    redirect_to root_path, notice: "[SISTEMA] Missão removida.", status: :see_other
  end

  private

  def set_habit
    @habit = current_user.habits.find(params[:id])
  end

  def habit_params
    params.require(:habit).permit(:name, :category, :xp_reward)
  end
end
