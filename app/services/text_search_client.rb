class TextSearchClient
  Faraday.register_middleware(:response, :logging => Echo::ClientMiddleware::LoggingMiddleware)

  TEXT_SEARCH_URL = ENV['text_search_url']

  def self.parse_text(text)
    connection.get('/api/v0/context_parsing', {text: text}).body
  end

  def self.connection
    Thread.current[:edsc_text_search_connection] ||= self.build_connection
  end

  private

  def self.get(url, params={})
    connection.post(url, params)
  end

  def self.build_connection
    Faraday.new(:url => TEXT_SEARCH_URL) do |conn|
      conn.response :logging
      conn.response :json, :content_type => /\bjson$/
      conn.adapter  Faraday.default_adapter
    end
  end
end