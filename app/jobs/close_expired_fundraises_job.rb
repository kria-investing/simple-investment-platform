class CloseExpiredFundraisesJob
  include Sidekiq::Worker
  sidekiq_options queue: 'close_expired_fundraises_job'

  def perform
    Fundraise.where(status: :open).where('ends_at <= ?', Time.current).find_each do |fundraise|
      fundraise.update(status: :closed)
    end
  end
end
