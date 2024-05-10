require 'spec_helper'

RSpec.describe PopEngine::AssessmentType do
  let(:assessment_type_data) do
    {
      'position_id' => 675,
      'aname' => 'Sales Management'
    }
  end

  subject { described_class.new(assessment_type_data) }

  it 'should have the given assessment type data' do
    expect(subject.position_id).to eq assessment_type_data['position_id']
    expect(subject.aname).to eq assessment_type_data['aname']
  end

  it 'should have the aliased attribs as well' do
    expect(subject.id).to eq subject.position_id
    expect(subject.name).to eq subject.aname
  end
end
