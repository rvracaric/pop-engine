module PopEngine
  class AssessmentsResource < Resource
    def create(**request_options)
      request_options[:language_id] ||= client.language_id
      custom_fields = prepare_custom_fields(request_options)
      request_options[:position_id] ||= request_options.delete(:assessment_type_id) # Alias for position_id

      request_body = { command: 'application_create', partner_api: true }.merge!(**request_options, **custom_fields)
      Assessment.new(post_request(body: request_body).body)
    end

    def list(**options)
      response = post_request(body: request_body_with_pagination('application_get', options))
      Collection.from_response(response.body, key: 'application_list', type: Assessment)
    end

    def retrieve(assessment_id, **options)
      Assessment.new(post_request(body: { command: 'application_get', partner_api: true, application_id: assessment_id, **options }).body)
    end

    def links(assessment_id, **options)
      response = post_request(body: { command: 'application_get_link', partner_api: true, application_id: assessment_id, **options })
      response.body.merge!(application_id: assessment_id) # Assessment id isn't returned in the response

      Assessment.new(response.body)
    end

    def scores(assessment_id, **options)
      options[:language_id] ||= client.language_id

      # Include additional information in the response
      %i(traits super_traits reducers answers).each do |feature_group|
        show_group = options.fetch(feature_group, options.fetch("show_#{feature_group}".to_sym, true)) # Allow for different naming conventions
        options["show_#{feature_group}".to_sym] = show_group
        options.delete(feature_group)
      end

      request_body = { command: 'score_calc_get', partner_api: true, application_id: assessment_id, **options }

      response = post_request(body: request_body)
      response.body.merge!(application_id: assessment_id) # Since assessment id isn't returned in the response

      Assessment.new(response.body)
    end

    private

    def prepare_custom_fields(request_options)
      api_format = "[{ n: 'field1', v: 'value1' }, { n: 'field2', v: 'value2' }, ...]"
      friendly_format = "{ field1: 'value1', field2: 'value2', ... }"

      fields = request_options.delete(:fields) || {}

      # Allowing for friendly field names to be passed in
      candidate_email = request_options.delete(:candidate_email) || request_options.delete(:email)
      candidate_name = request_options.delete(:candidate_name) || request_options.delete(:app_full_name)

      case fields
      when Hash
        # Assuming the friendly format

        # Giving priority to API field names, but keeping the friendly names as fallbacks
        fields[:email] ||= candidate_email || fields.delete(:candidate_email)
        fields[:app_full_name] ||= candidate_name || fields.delete(:candidate_name)

        # Convert to API format
        return { fields: fields.map{ |k, v| { n: k, v: v } } }

      when Array
        # Assuming the API format

        # Giving priority to existing fields in the array
        has_email = fields.any?{ |f| [:email, 'email'].include?(f[:n]) }
        has_name = fields.any?{ |f| [:app_full_name, 'app_full_name'].include?(f[:n]) }

        fields << { n: :email, v: candidate_email } unless has_email
        fields << { n: :app_full_name, v: candidate_name } unless has_name

        return { fields: fields }

      else
        raise ArgumentError, "fields must be a hash (#{friendly_format}) or array of hashes in API format (#{api_format})"
      end
    end
  end
end
