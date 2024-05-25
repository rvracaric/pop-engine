module PopEngine
  class Client
    API_URL = 'https://pop.selfmgmt.com/api/1.0'
    DEFAULT_LANGUAGE_ID = 'eng'

    attr_reader :username, :password, :language_id, :adapter

    def initialize(username:, password:, language_id: DEFAULT_LANGUAGE_ID, adapter: Faraday.default_adapter, stubs: nil)
      @username = username
      @password = password
      @adapter = adapter
      @language_id = language_id

      # For test requests
      @stubs = stubs
    end

    %i(assessments assessment_types).each do |resource|
      define_method(resource) do
        resource_type = resource.to_s.split('_').map(&:capitalize).join
        PopEngine.const_get("#{resource_type}Resource").new(self)
      end
    end

    def connection
      @connection ||= Faraday.new(API_URL) do |conn|
        conn.basic_auth(username, password)
        conn.headers['Content-Type'] = 'application/json'
        conn.adapter adapter, @stubs
      end
    end
  end
end
