module PopEngine
  class AssessmentFamily < Object
    alias_attrib_names id: :report_id,
                       name: :report_name,
                       title: :report_title,
                       assessment_types: :positions

    def initialize(attrs = {})
      attrs['positions'] = Collection.from_response(attrs, key: 'positions', type: AssessmentType) if attrs['positions']

      super attrs
    end

    def languages
      lang_list.to_s.split(',').map(&:strip).reject(&:empty?)
    end
  end
end
