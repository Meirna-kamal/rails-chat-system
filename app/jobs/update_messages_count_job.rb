class UpdateMessagesCountJob
  include Sidekiq::Job

  def perform(*args)
    Chat.find_each do |chat|
      chat.update(messages_count: chat.messages.count)
    end
  end
end
