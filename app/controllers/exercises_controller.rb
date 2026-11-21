# app/controllers/exercises_controller.rb
class ExercisesController < ApplicationController
  before_action :set_workout
  before_action :set_exercise, only: %i[edit update destroy]

  def new
    @exercise = @workout.exercises.build
  end

  def create
    @exercise = @workout.exercises.build(exercise_params)
    if @exercise.save
      redirect_to workout_path(@workout), notice: "[SISTEMA] Exercício adicionado."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @exercise.update(exercise_params)
      redirect_to workout_path(@workout), notice: "[SISTEMA] Exercício atualizado."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @exercise.destroy
    redirect_to workout_path(@workout), notice: "[SISTEMA] Exercício removido.", status: :see_other
  end

  private

  def set_workout
    @workout = current_user.workouts.find(params[:workout_id])
  end

  def set_exercise
    @exercise = @workout.exercises.find(params[:id])
  end

  def exercise_params
    params.require(:exercise).permit(:name, :details, :xp_reward)
  end
end
