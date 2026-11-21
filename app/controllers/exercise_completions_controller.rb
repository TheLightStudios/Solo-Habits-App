# app/controllers/exercise_completions_controller.rb
class ExerciseCompletionsController < ApplicationController
  def create
    workout = current_user.workouts.find(params[:workout_id])
    exercise = workout.exercises.find(params[:exercise_id])
    level_before = current_user.level

    completion = exercise.exercise_completions.build(user: current_user, completed_on: Date.current)

    if completion.save
      message = "[SISTEMA] Exercício concluído: #{exercise.name} (+#{exercise.xp_reward} XP)."
      if current_user.level > level_before
        message += " LEVEL UP! Você alcançou o nível #{current_user.level}. Distribua seus pontos em Status."
      end
      redirect_to workout_path(workout), notice: message
    else
      redirect_to workout_path(workout), alert: "[ALERTA] Exercício já concluído hoje."
    end
  end
end
