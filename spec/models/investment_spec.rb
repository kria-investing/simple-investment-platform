require "rails_helper"

RSpec.describe Investment, type: :model do
  describe "associations" do
    it "belongs to user" do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it "belongs to fundraise" do
      association = described_class.reflect_on_association(:fundraise)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe "validations" do
    let(:user) { create(:user) }
    let(:fundraise) { create(:fundraise, status: :open) }

    it "is valid with valid attributes" do
      investment = build(:investment, user: user, fundraise: fundraise, amount_cents: 10_000)
      expect(investment).to be_valid
    end

    it "is invalid without amount_cents" do
      investment = build(:investment, user: user, fundraise: fundraise, amount_cents: nil)
      expect(investment).not_to be_valid
      expect(investment.errors[:amount_cents]).to be_present
    end

    it "is invalid with amount_cents equal to zero" do
      investment = build(:investment, user: user, fundraise: fundraise, amount_cents: 0)
      expect(investment).not_to be_valid
      expect(investment.errors[:amount_cents]).to be_present
    end

    it "is invalid with negative amount_cents" do
      investment = build(:investment, user: user, fundraise: fundraise, amount_cents: -100)
      expect(investment).not_to be_valid
      expect(investment.errors[:amount_cents]).to be_present
    end

    it "is invalid if fundraise is closed" do
      closed_fundraise = create(:fundraise, status: :closed)
      investment = build(:investment, user: user, fundraise: closed_fundraise, amount_cents: 10_000)
      expect(investment).not_to be_valid
      expect(investment.errors[:fundraise]).to include("deve estar aberta para receber investimentos")
    end
  end

  describe "#amount getter and setter" do
    let(:user) { create(:user) }
    let(:fundraise) { create(:fundraise, status: :open) }
    let(:investment) { create(:investment, user: user, fundraise: fundraise) }

    it "converts cents to decimal" do
      investment.amount_cents = 100_000
      expect(investment.amount).to eq(1000.0)
    end

    it "converts decimal to cents" do
      investment.amount = 1500.50
      expect(investment.amount_cents).to eq(150_050)
    end

    it "handles string input" do
      investment.amount = "250.75"
      expect(investment.amount_cents).to eq(25_075)
    end
  end

  describe "database constraints" do
    it "requires user_id" do
      expect {
        Investment.create!(fundraise: create(:fundraise), amount_cents: 10_000)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "requires fundraise_id" do
      expect {
        Investment.create!(user: create(:user), amount_cents: 10_000)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
