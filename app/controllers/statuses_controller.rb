class StatusesController < ApplicationController
  def show; end

  def allocate
    if current_user.spend_attribute_point!(params[:attribute])
      redirect_to status_path, notice: "[SISTEMA] Ponto distribuído."
    else
      redirect_to status_path, alert: "[ALERTA] Sem pontos disponíveis."
    end
  end
end
