module Messages
  class ExternalApi::InMemory
    def call(phone, content)
      { success: true }
    end
  end
end