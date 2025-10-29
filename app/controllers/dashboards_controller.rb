class DashboardsController < ApplicationController
  def index
    @total_users = User.count
    @total_fundraises = Fundraise.count
    @total_investments = Investment.count
    @total_invested = Investment.sum(:amount_cents) / 100.0

    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_fundraises = Fundraise.order(created_at: :desc).limit(5)
    @recent_investments = Investment.includes(:user, :fundraise).order(created_at: :desc).limit(5)

    @investments_by_user = User.joins(:investments)
                              .group('users.name')
                              .sum('investments.amount_cents')
                              .transform_values { |v| v / 100.0 }
                              .sort_by { |_k, v| -v }
                              .first(10)
                              .to_h
  end
end
