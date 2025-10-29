require "rails_helper"

RSpec.describe Fundraise, type: :model do
  describe "associations" do
    it "has many investments" do
      association = described_class.reflect_on_association(:investments)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:restrict_with_error)
    end
  end

  describe "validations" do
    it "is valid with valid attributes" do
      fundraise = build(:fundraise)
      expect(fundraise).to be_valid
    end

    it "is invalid without a title" do
      fundraise = build(:fundraise, title: nil)
      expect(fundraise).not_to be_valid
    end

    it "validates ends_at is after starts_at" do
      fundraise = build(:fundraise, starts_at: Time.current, ends_at: 1.day.ago)
      expect(fundraise).not_to be_valid
      expect(fundraise.errors[:ends_at]).to include("deve ser após o início")
    end
  end

  describe "#total_raised_cents" do
    let(:fundraise) { create(:fundraise) }
    let(:user) { create(:user) }

    it "returns zero when fundraise has no investments" do
      expect(fundraise.total_raised_cents).to eq(0)
    end

    it "returns sum of all investments" do
      create(:investment, user: user, fundraise: fundraise, amount_cents: 15_000)
      create(:investment, user: user, fundraise: fundraise, amount_cents: 30_000)
      expect(fundraise.total_raised_cents).to eq(45_000)
    end
  end

  describe "#total_raised" do
    let(:fundraise) { create(:fundraise) }
    let(:user) { create(:user) }

    it "returns total in decimal format" do
      create(:investment, user: user, fundraise: fundraise, amount_cents: 200_000)
      expect(fundraise.total_raised).to eq(2000.0)
    end
  end

  describe "#percentage_raised" do
    let(:fundraise) { create(:fundraise, target_cents: 100_000) }
    let(:user) { create(:user) }

    it "returns 0 when target is zero" do
      fundraise.target_cents = 0
      expect(fundraise.percentage_raised).to eq(0)
    end

    it "calculates percentage correctly" do
      create(:investment, user: user, fundraise: fundraise, amount_cents: 25_000)
      expect(fundraise.percentage_raised).to eq(25.0)
    end

    it "can exceed 100%" do
      create(:investment, user: user, fundraise: fundraise, amount_cents: 150_000)
      expect(fundraise.percentage_raised).to eq(150.0)
    end
  end
end
