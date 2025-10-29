class Investment < ApplicationRecord
  belongs_to :user, inverse_of: :investments
  belongs_to :fundraise, inverse_of: :investments

  validates :amount_cents, numericality: { only_integer: true, greater_than: 0 }
  validate :fundraise_must_be_open

  def self.ransackable_attributes(auth_object = nil)
    [ 'id', 'user_id', 'fundraise_id', 'amount_cents', 'created_at', 'updated_at' ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ 'fundraise', 'user' ]
  end

  def amount
    amount_cents.to_d / 100
  end

  def amount=(value)
    self.amount_cents = (BigDecimal(value.to_s) * 100).to_i
  end

  private

  def fundraise_must_be_open
    return if fundraise.blank?
    errors.add(:fundraise, 'deve estar aberta para receber investimentos') unless fundraise.open?
  end
end
