# app/controllers/journal_entries_controller.rb
class JournalEntriesController < ApplicationController
  before_action :set_entry, only: %i[edit update destroy]

  def index
    @entries = current_user.journal_entries.order(entry_date: :desc)
    @today_entry = current_user.journal_entries.find_by(entry_date: Date.current)
  end

  def new
    today = current_user.journal_entries.find_by(entry_date: Date.current)
    return redirect_to edit_journal_entry_path(today) if today

    @entry = current_user.journal_entries.build(entry_date: Date.current)
  end

  def create
    @entry = current_user.journal_entries.build(entry_params)
    @entry.entry_date = Date.current

    if @entry.save
      redirect_to journal_entries_path, notice: "[SISTEMA] Registro do dia salvo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @entry.update(entry_params)
      redirect_to journal_entries_path, notice: "[SISTEMA] Registro atualizado."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @entry.destroy
    redirect_to journal_entries_path, notice: "[SISTEMA] Registro apagado.", status: :see_other
  end

  private

  def set_entry
    @entry = current_user.journal_entries.find(params[:id])
  end

  def entry_params
    params.require(:journal_entry).permit(:content)
  end
end
