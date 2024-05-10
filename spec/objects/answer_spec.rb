require 'spec_helper'

RSpec.describe PopEngine::Answer do
  let(:answer_data) { JSON.parse(File.read('spec/fixtures/assessments/scores.json'))['answers'].first }

  subject { described_class.new(answer_data) }

  it 'should have the given answer data' do
    expect(subject.q).to eq answer_data['q']
    expect(subject.a).to eq answer_data['a']
    expect(subject.c).to eq answer_data['c']
    expect(subject.t).to eq answer_data['t']
    expect(subject.v).to eq answer_data['v']
  end

  it 'should have user-friendly aliased attribs' do
    expect(subject.response).to eq answer_data['a']
    expect(subject.choice_text).to eq answer_data['v']
  end

  it 'should have a question object' do
    expect(subject.question).to be_a PopEngine::Question
    expect(subject.question.id).to eq answer_data['q']
    expect(subject.question.name).to eq answer_data['c']
    expect(subject.question.text).to eq answer_data['t']
  end

  context 'when the answer is a text typed in by the candidate' do
    let(:answer_data) { JSON.parse(File.read('spec/fixtures/assessments/scores.json'))['answers'].last }

    it 'should have a candidate_response' do
      expect(subject.response).to eq answer_data['a']
    end

    it 'should not have a choice_text which is only for multiple-choice questions' do
      expect(subject.choice_text).to be_nil
    end
  end
end
