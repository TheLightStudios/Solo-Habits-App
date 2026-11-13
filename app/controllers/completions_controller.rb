class CompletionsController < ApplicationController
  def create
    habit = current_user.habits.find(params[:habit_id])
    level_before = current_user.level

    completion = habit.completions.build(user: current_user, completed_on: Date.current)

    if completion.save
      message = "[SISTEMA] Missão Concluída: #{habit.name}"
      if current_user.level > level_before
        message += " LEVEL UP! Você alcançou o nível #{current_user.level}"
      end
      redirect_to root_path, notice: message
    else
      redirect_to root_path, alert: "[ALERTA] Missão já concluída no dia de hoje!"
    end
  end
end
