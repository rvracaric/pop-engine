require 'faraday'
require_relative 'pop_engine/version'

module PopEngine
  autoload :Client, 'pop_engine/client'
  autoload :Collection, 'pop_engine/collection'
  autoload :Object, 'pop_engine/object'
  autoload :Resource, 'pop_engine/resource'
  autoload :Error, 'pop_engine/error'

  # Categories of POP Engine API calls
  autoload :AssessmentsResource, 'pop_engine/resources/assessments'
  autoload :AssessmentTypesResource, 'pop_engine/resources/assessment_types'

  # Used to return a nicer object wrapping the response data
  autoload :Answer, 'pop_engine/objects/answer'
  autoload :Assessment, 'pop_engine/objects/assessment'
  autoload :AssessmentType, 'pop_engine/objects/assessment_type'
  autoload :Candidate, 'pop_engine/objects/candidate'
  autoload :CustomFields, 'pop_engine/objects/custom_fields'
  autoload :Trait, 'pop_engine/objects/trait'
  autoload :SuperTrait, 'pop_engine/objects/super_trait'
  autoload :Reducer, 'pop_engine/objects/reducer'
  autoload :Question, 'pop_engine/objects/question'
end
