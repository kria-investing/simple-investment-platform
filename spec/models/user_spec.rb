require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it "has many investments" do
      association = described_class.reflect_on_association(:investments)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe "validations" do
    it "is valid with valid attributes" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "is invalid without a name" do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
    end

    it "is invalid without an email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it "is invalid with duplicate email" do
      create(:user, email: "test@example.com")
      user = build(:user, email: "test@example.com")
      expect(user).not_to be_valid
    end
  end

  describe "#total_invested_cents" do
    let(:user) { create(:user) }
    let(:fundraise) { create(:fundraise) }

    it "returns zero when user has no investments" do
      expect(user.total_invested_cents).to eq(0)
    end

    it "returns sum of all investments" do
      create(:investment, user: user, fundraise: fundraise, amount_cents: 10_000)
      create(:investment, user: user, fundraise: fundraise, amount_cents: 25_000)
      expect(user.total_invested_cents).to eq(35_000)
    end
  end

  describe "#total_invested" do
    let(:user) { create(:user) }
    let(:fundraise) { create(:fundraise) }

    it "returns total in decimal format" do
      create(:investment, user: user, fundraise: fundraise, amount_cents: 100_000)
      expect(user.total_invested).to eq(1000.0)
    end
  end
end
