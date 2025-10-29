require "rails_helper"

RSpec.describe "Investments", type: :request do
  let(:user) { create(:user) }
  let(:fundraise) { create(:fundraise, status: :open) }
  let(:valid_attributes) do
    {
      user_id: user.id,
      fundraise_id: fundraise.id,
      amount_cents: 50_000
    }
  end
  let(:invalid_attributes) do
    {
      user_id: user.id,
      fundraise_id: fundraise.id,
      amount_cents: 0
    }
  end

  describe "GET /investments" do
    it "returns a successful response" do
      get investments_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /investments/:id" do
    let(:investment) { create(:investment, user: user, fundraise: fundraise) }

    it "returns a successful response" do
      get investment_path(investment)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /investments/new" do
    it "returns a successful response" do
      get new_investment_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /investments/:id/edit" do
    let(:investment) { create(:investment, user: user, fundraise: fundraise) }

    it "returns a successful response" do
      get edit_investment_path(investment)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /investments" do
    context "with valid parameters" do
      it "creates a new Investment" do
        expect {
          post investments_path, params: { investment: valid_attributes }
        }.to change(Investment, :count).by(1)
      end

      it "redirects to the created investment" do
        post investments_path, params: { investment: valid_attributes }
        expect(response).to redirect_to(investment_path(Investment.last))
      end

      it "sets a success notice" do
        post investments_path, params: { investment: valid_attributes }
        expect(flash[:notice]).to match(/criado com sucesso/)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Investment" do
        expect {
          post investments_path, params: { investment: invalid_attributes }
        }.not_to change(Investment, :count)
      end

      it "returns unprocessable_entity status" do
        post investments_path, params: { investment: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when fundraise is closed" do
      let(:closed_fundraise) { create(:fundraise, status: :closed) }
      let(:closed_attributes) do
        {
          user_id: user.id,
          fundraise_id: closed_fundraise.id,
          amount_cents: 50_000
        }
      end

      it "does not create a new Investment" do
        expect {
          post investments_path, params: { investment: closed_attributes }
        }.not_to change(Investment, :count)
      end
    end
  end

  describe "PATCH /investments/:id" do
    let(:investment) { create(:investment, user: user, fundraise: fundraise) }
    let(:new_attributes) { { amount_cents: 75_000 } }

    context "with valid parameters" do
      it "updates the requested investment" do
        patch investment_path(investment), params: { investment: new_attributes }
        investment.reload
        expect(investment.amount_cents).to eq(75_000)
      end

      it "redirects to the investment" do
        patch investment_path(investment), params: { investment: new_attributes }
        expect(response).to redirect_to(investment_path(investment))
      end

      it "sets a success notice" do
        patch investment_path(investment), params: { investment: new_attributes }
        expect(flash[:notice]).to match(/atualizado com sucesso/)
      end
    end

    context "with invalid parameters" do
      it "returns unprocessable_entity status" do
        patch investment_path(investment), params: { investment: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /investments/:id" do
    let!(:investment) { create(:investment, user: user, fundraise: fundraise) }

    it "destroys the requested investment" do
      expect {
        delete investment_path(investment)
      }.to change(Investment, :count).by(-1)
    end

    it "redirects to the investments list" do
      delete investment_path(investment)
      expect(response).to redirect_to(investments_path)
    end

    it "sets a success notice" do
      delete investment_path(investment)
      expect(flash[:notice]).to match(/removido com sucesso/)
    end
  end
end
