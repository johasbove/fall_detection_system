module Messages
  class ExternalApi::HttpClient
    def self.call(phone, content)
      # To implement
      { body: { success: true } }
    end
  end
end