require 'spec_helper'

RSpec.describe PopEngine::Question do
  let(:question_data) do
    {
      'id' => '42',
      'name' => 'Question 42',
      'text' => 'What is the answer to the ultimate question of life, the universe, and everything?'
    }
  end

  subject { described_class.new(question_data) }

  it 'should have the given question data' do
    expect(subject.id).to eq question_data['id']
    expect(subject.name).to eq question_data['name']
    expect(subject.text).to eq question_data['text']
  end
end
