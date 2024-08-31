class ClientApplication < ApplicationRecord
    before_validation :generate_token, on: :create

    validates :name, presence: true, length: { maximum: 255 }
    validates :token, presence: true, uniqueness: true

    private
    def generate_token
        self.token = SecureRandom.uuid
    end
end
