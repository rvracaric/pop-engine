module PopEngine
  class Assessment < Object
    alias_attrib_names id: :application_id,
                       type_id: :position_id,
                       type_name: :position,
                       url: :app_link_full,
                       report_url: :rep_link_full,
                       advanced_report_url: :rep_link_full_acc,
                       completed_on: :completed,
                       expires_on: :expires,
                       started_on: :started,
                       reducers: :position_reducers

    def initialize(attrs = {})
      if attrs['fields']
        attrs['fields'] = CustomFields.new(attrs['fields'])
        attrs['candidate'] = Candidate.new(name: attrs['fields']['app_full_name'], email: attrs['fields']['email'])
      else
        # create empty objects
        attrs['fields'] = CustomFields.new
        attrs['candidate'] = Candidate.new
      end

      attrs['answers'] = Collection.from_response(attrs, key: 'answers', type: Answer) if attrs['answers']
      attrs['traits'] = Collection.from_response(attrs, key: 'traits', type: Trait) if attrs['traits']
      attrs['super_traits'] = Collection.from_response(attrs, key: 'super_traits', type: SuperTrait) if attrs['super_traits']
      attrs['position_reducers'] = Collection.from_response(attrs, key: 'position_reducers', type: Reducer) if attrs['position_reducers']

      super attrs
    end
  end
end
