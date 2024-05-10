module PopEngine
  class Answer < Object
    alias_attrib_names response: :a, # Candidate's input. A string for text questions, an integer for multiple-choice questions
                       choice_text: :v # For multiple-choice questions only. The text of the candidate's choice

    def initialize(attrs = {})
      attrs['question'] = Question.new(id: attrs['q'], name: attrs['c'], text: attrs['t'])
      super attrs
    end
  end
end
