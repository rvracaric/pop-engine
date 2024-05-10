require 'spec_helper'

RSpec.describe PopEngine::Candidate do
  let(:candidate_data) do
    {
      'name' => 'James Bond',
      'email' => '007@jbond.com'
    }
  end

  subject { described_class.new(candidate_data) }

  it 'should have the given candidate data' do
    expect(subject.name).to eq candidate_data['name']
    expect(subject.email).to eq candidate_data['email']
  end
end
