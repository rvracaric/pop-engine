module PopEngine
  class Resource
    MAX_PAGE_SIZE = 1000
    MIN_PAGE_SIZE = 2

    attr_reader :client

    def initialize(client)
      @client = client
    end

    private

    def post_request(body:, headers: {})
      handle_response client.connection.post('', JSON.generate(body), headers)
    end

    def handle_response(response)
      body = JSON.parse(response.body)

      # Response status from the POP Engine is always 200 OK. The error code is provided in the body.
      raise Error, "Unable to perform the request due to server-side problems. #{body['error']}" unless response.status == 200
      return body if body['error_code'] == 0

      raise Error, "Error code: #{body['error_code']}. #{body['error_text']}"
    end

    def request_body_with_pagination(command, options = {})
      # Allow for different naming conventions
      per_page = options.delete(:max_count) || options.delete(:per_page)
      raise ArgumentError, "per_page (or its alias max_count) must be between #{MIN_PAGE_SIZE} and #{MAX_PAGE_SIZE}" if per_page unless (MIN_PAGE_SIZE..MAX_PAGE_SIZE).cover?(per_page)

      start_assessment_id = options.delete(:start_app_id) || options.delete(:start_assessment_id)
      start_account_id = options.delete(:start_acc_id) || options.delete(:start_account_id)
      start_date = options.delete(:start_date)

      request_body = { command: command, partner_api: true, **options }
      request_body.merge!(max_count: per_page) if per_page
      request_body.merge!(start_date: start_date, start_app_id: start_assessment_id, start_acc_id: start_account_id) if start_assessment_id || start_account_id || start_date

      request_body
    end
  end
end
