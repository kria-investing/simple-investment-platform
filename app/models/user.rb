# app/models/user.rb
class User < ApplicationRecord
  has_many :investments, inverse_of: :user, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  def self.ransackable_attributes(auth_object = nil)
    [ 'created_at', 'email', 'id', 'name', 'updated_at' ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ 'investments' ]
  end

  def total_invested_cents
    investments.sum(:amount_cents)
  end

  def total_invested
    total_invested_cents.to_d / 100
  end
end
