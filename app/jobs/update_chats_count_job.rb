class UpdateChatsCountJob
  include Sidekiq::Job

  def perform
    ClientApplication.find_each do |application|
      application.update(chats_count: application.chats.count)
    end
  end
end
