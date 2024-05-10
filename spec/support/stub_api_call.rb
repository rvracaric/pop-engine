require 'json'

def stub_request(response:, method: :post, body: {})
  Faraday::Adapter::Test::Stubs.new do |stub|
    arguments = [method, PopEngine::Client::API_URL]
    arguments << body.to_json if [:post, :put, :patch].include?(method)
    stub.send(*arguments) { |env| response }
  end
end

def stub_response(fixture:, status: 200, headers: { 'Content-Type' => 'application/json' })
  [status, headers, File.read("spec/fixtures/#{fixture}.json")]
end
