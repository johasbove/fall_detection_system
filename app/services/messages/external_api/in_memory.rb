module Messages
  class ExternalApi::InMemory
    def self.call(phone, content)
      { body: { success: true } }
    end
  end
end