require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe CloseExpiredFundraisesJob, type: :job do
  before { Sidekiq::Testing.inline! }

  let!(:fundraise_open_expired) { create(:fundraise, :past, status: :open) }
  let!(:fundraise_open_future)  { create(:fundraise, starts_at: 1.day.ago, ends_at: 1.day.from_now, status: :open) }
  let!(:fundraise_closed_expired) { create(:fundraise, :past, status: :closed) }

  it 'close expired fundraises opened' do
    expect {
      CloseExpiredFundraisesJob.perform_async
      fundraise_open_expired.reload
    }.to change { fundraise_open_expired.status }.from('open').to('closed')
  end

  it 'does not close fundraises opened that have not expired' do
    expect {
      CloseExpiredFundraisesJob.perform_async
      fundraise_open_future.reload
    }.not_to change { fundraise_open_future.status }
  end

  it 'does not change fundraises closed' do
    expect {
      CloseExpiredFundraisesJob.perform_async
      fundraise_closed_expired.reload
    }.not_to change { fundraise_closed_expired.status }
  end
end
