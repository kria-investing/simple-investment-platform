class Fundraise < ApplicationRecord
  extend Enumerize

  has_many :investments, inverse_of: :fundraise, dependent: :restrict_with_error

  enumerize :status, in: [
    :open,
    :closed
  ], predicates: true

  validates :title, presence: true, length: { maximum: 255 }
  validates :target_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :ends_after_starts

  def self.ransackable_attributes(auth_object = nil)
    [ 'id', 'title', 'description', 'status', 'target_cents', 'starts_at', 'ends_at', 'created_at', 'updated_at' ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ 'investments' ]
  end

  def target
    target_cents.to_d / 100
  end

  def target=(amount)
    self.target_cents = (BigDecimal(amount.to_s) * 100).to_i
  end

  def total_raised_cents
    investments.sum(:amount_cents)
  end

  def total_raised
    total_raised_cents.to_d / 100
  end

  def percentage_raised
    return 0 if target_cents.zero?
    (total_raised_cents.to_f / target_cents * 100).round(2)
  end

  private

  def ends_after_starts
    return if starts_at.blank? || ends_at.blank?
    errors.add(:ends_at, 'deve ser após o início') if ends_at < starts_at
  end
end
