# app/controllers/purchases_controller.rb
class PurchasesController < ApplicationController
  def create
    reward = current_user.rewards.active.find(params[:reward_id])

    if current_user.buy!(reward)
      redirect_to rewards_path, notice: "[SISTEMA] Compra realizada: #{reward.name}. Aproveite, Caçador."
    else
      redirect_to rewards_path, alert: "[ALERTA] Moedas insuficientes."
    end
  end
end
