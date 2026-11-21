# app/controllers/schedule_items_controller.rb
class ScheduleItemsController < ApplicationController
  before_action :set_item, only: %i[edit update destroy]

  def index
    @items = current_user.schedule_items.order(:start_time, :created_at).to_a
    @now = Time.current.strftime("%H:%M")
    @current_item = @items.select { |i| i.start_time <= @now }.last
    @next_item = @items.find { |i| i.start_time > @now }
  end

  def new
    @item = current_user.schedule_items.build
  end

  def create
    @item = current_user.schedule_items.build(item_params)
    if @item.save
      redirect_to schedule_items_path, notice: "[SISTEMA] Horário adicionado à agenda."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @item.update(item_params)
      redirect_to schedule_items_path, notice: "[SISTEMA] Horário atualizado."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to schedule_items_path, notice: "[SISTEMA] Horário removido.", status: :see_other
  end

  private

  def set_item
    @item = current_user.schedule_items.find(params[:id])
  end

  def item_params
    params.require(:schedule_item).permit(:start_time, :title)
  end
end
