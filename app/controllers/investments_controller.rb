class InvestmentsController < ApplicationController
  before_action :set_investment, only: %i[show edit update destroy]

  def index
    @q = Investment.ransack(params[:q])
    @investments = @q.result(distinct: false)
                    .includes(:user, :fundraise)
                    .order(created_at: :desc)
  end

  def show; end

  def new
    @investment = Investment.new
    @users = User.order(:name)
    @fundraises = Fundraise.where(status: :open).order(:title)
  end

  def edit
    @users = User.order(:name)
    @fundraises = Fundraise.order(:title)
  end

  def create
    @investment = Investment.new(investment_params)
    if @investment.save
      redirect_to @investment, notice: "Investimento criado com sucesso."
    else
      @users = User.order(:name)
      @fundraises = Fundraise.where(status: :open).order(:title)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @investment.update(investment_params)
      redirect_to @investment, notice: "Investimento atualizado com sucesso."
    else
      @users = User.order(:name)
      @fundraises = Fundraise.order(:title)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @investment.destroy
      redirect_to investments_url, notice: "Investimento removido com sucesso."
    else
      redirect_to @investment, alert: @investment.errors.full_messages.to_sentence
    end
  end

  private

  def set_investment
    @investment = Investment.includes(:user, :fundraise).find(params[:id])
  end

  def investment_params
    params.require(:investment).permit(:user_id, :fundraise_id, :amount, :amount_cents)
  end
end
