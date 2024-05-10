require 'spec_helper'
require 'support/stub_api_call'

RSpec.describe PopEngine::AssessmentTypesResource do
  let(:client) { PopEngine::Client.new(username: 'fake', password: 'fake', adapter: :test, stubs: stub) }

  let(:stub) do
    stub_request(response: stub_response(fixture: 'assessment_types/list'),
                 body: { command: 'position_get', partner_api: true })
  end

  subject { client.assessment_types }

  describe '#list' do
    it 'should return a collection of assessment types' do
      assessment_types = subject.list

      expect(assessment_types).to be_a PopEngine::Collection
      expect(assessment_types.first).to be_a PopEngine::AssessmentType
      expect(assessment_types.count).to eq 3
    end
  end
end
