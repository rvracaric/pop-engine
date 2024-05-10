module PopEngine
  class AssessmentTypesResource < Resource
    def list(**options)
      response = post_request(body: request_body_with_pagination('position_get', options))
      Collection.from_response(response.body, key: 'items', type: AssessmentType)
    end
  end
end
