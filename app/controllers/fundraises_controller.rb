# app/controllers/fundraises_controller.rb
class FundraisesController < ApplicationController
  before_action :set_fundraise, only: %i[show edit update destroy]

  def index
    @fundraises = Fundraise.order(created_at: :desc)
  end

  def show; end

  def new
    @fundraise = Fundraise.new
  end

  def edit; end

  def create
    @fundraise = Fundraise.new(fundraise_params)
    if @fundraise.save
      redirect_to @fundraise, notice: "Oferta criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @fundraise.update(fundraise_params)
      redirect_to @fundraise, notice: "Oferta atualizada com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @fundraise.destroy
      redirect_to fundraises_url, notice: "Oferta removida com sucesso."
    else
      redirect_to @fundraise, alert: @fundraise.errors.full_messages.to_sentence
    end
  end

  private

  def set_fundraise
    @fundraise = Fundraise.find(params[:id])
  end

  def fundraise_params
    params.require(:fundraise).permit(:title, :description, :status, :starts_at, :ends_at, :target, :target_cents)
  end
end
