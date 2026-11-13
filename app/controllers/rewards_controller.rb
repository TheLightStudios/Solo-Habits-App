# app/controllers/rewards_controller.rb
class RewardsController < ApplicationController
  before_action :set_reward, only: %i[edit update destroy]

  def index
    @rewards = current_user.rewards.active.order(:cost)
    @purchases = current_user.purchases.order(created_at: :desc).limit(10)
  end

  def new
    @reward = current_user.rewards.build
  end

  def create
    @reward = current_user.rewards.build(reward_params)
    if @reward.save
      redirect_to rewards_path, notice: "[SISTEMA] Item adicionado à loja."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @reward.update(reward_params)
      redirect_to rewards_path, notice: "[SISTEMA] Item atualizado."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @reward.destroy
    redirect_to rewards_path, notice: "[SISTEMA] Item removido da loja.", status: :see_other
  end

  private

  def set_reward
    @reward = current_user.rewards.find(params[:id])
  end

  def reward_params
    params.require(:reward).permit(:name, :cost)
  end
end
