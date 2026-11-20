module PopEngine
  class AssessmentTypesResource < Resource
    def list(**options)
      response = post_request(body: request_body_with_pagination('position_get', options))
      Collection.from_response(response, key: 'items', type: AssessmentType)
    end

    def list_by_family(**options)
      response = post_request(body: request_body_with_pagination('position_get', options.merge(extra_info: true, cmd_ver: 1)))
      Collection.from_response(response, key: 'reports', type: AssessmentFamily)
    end
  end
end
