class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :chat

  before_validation :set_message_number, on: :create

  validates :message_number, presence: true, uniqueness: { scope: [:chat_id] }
  validates :message_number, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :message_body, presence: true

  # Elasticsearch index settings and mappings
  settings index: { number_of_shards: 1, number_of_replicas: 0 } do
    mappings dynamic: false do
      indexes :message_body, type: :text, analyzer: 'standard'
      indexes :chat_id, type: :integer  
    end
  end

  # Customizes how the data is indexed in Elasticsearch
  def as_indexed_json(options = {})
    as_json(only: [:message_body, :message_number, :chat_id])
  end

  # Searches messages by body and chat_id
  def self.search_message_body(query, chat_id)
    params = {
      query: {
        bool: {
          must: [
            {
              match_phrase_prefix: {
                message_body: query
              }
            },
            {
              term: {
                chat_id: chat_id
              }
            }
          ]
        }
      }
    }

    results = self.__elasticsearch__.search(params).records.to_a

    results.map do |record|
      {
        message_number: record.message_number,
        message_body: record.message_body
      }
    end
  end

  private
  def set_message_number
    Message.transaction do
      max_message_number = Message.where(chat_id: chat_id)
                            .lock("FOR UPDATE")
                            .maximum(:message_number) || 0
      self.message_number = max_message_number + 1
    end
  end
end
