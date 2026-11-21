# app/controllers/workouts_controller.rb
class WorkoutsController < ApplicationController
  before_action :set_workout, only: %i[show edit update destroy]

  def index
    @workouts = current_user.workouts.includes(:exercises).order(:created_at)
    @done_ids = done_exercise_ids
  end

  def show
    @exercises = @workout.exercises.order(:created_at)
    @done_ids = done_exercise_ids
  end

  def new
    @workout = current_user.workouts.build
  end

  def create
    @workout = current_user.workouts.build(workout_params)
    if @workout.save
      redirect_to workout_path(@workout), notice: "[SISTEMA] Rotina criada. Adicione os exercícios."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @workout.update(workout_params)
      redirect_to workout_path(@workout), notice: "[SISTEMA] Rotina atualizada."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @workout.destroy
    redirect_to workouts_path, notice: "[SISTEMA] Rotina removida.", status: :see_other
  end

  private

  def set_workout
    @workout = current_user.workouts.find(params[:id])
  end

  def workout_params
    params.require(:workout).permit(:name)
  end

  def done_exercise_ids
    current_user.exercise_completions.where(completed_on: Date.current).pluck(:exercise_id)
  end
end
