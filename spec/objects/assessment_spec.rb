require 'spec_helper'

RSpec.describe PopEngine::Assessment do
  let(:assessment_data) do
    {
      'application_id' => '75',
      'converted_from' => '0',
      'account_id' => '30',
      'position_id' => '10',
      'position' => 'Sales Management',
      'max_count' => 1,
      'has_followup' => false,
      'user_id' => 'test-user',
      'language_id' => 'eng',
      'is_reusable' => false,
      'app_type' => 0,
      'date' => '2024-04-22',
      'date_sub' => '2024-04-22',
      'date_exp' => '2034-04-20',
      'started' => '2024-04-22',
      'expires' => '2034-04-20',
      'status' => 'completed',
      'completed' => '2024-04-22',
      'app_link_full' => 'https://assessment/link',
      'rep_link_full' => 'https://assessment/report/link',
      'rep_link_full_acc' => 'https://assessment/report/link/acc'
    }
  end

  subject { described_class.new(assessment_data) }

  it 'should have the given assessment data' do
    assessment = described_class.new(assessment_data)

    assessment_data.each do |key, value|
      expect(assessment.send(key)).to eq value
    end
  end

  it 'should have the alias attribs as well' do
    expect(subject.id).to eq assessment_data['application_id']
    expect(subject.type_id).to eq assessment_data['position_id']
    expect(subject.type_name).to eq assessment_data['position']
    expect(subject.url).to eq assessment_data['app_link_full']
    expect(subject.report_url).to eq assessment_data['rep_link_full']
    expect(subject.advanced_report_url).to eq assessment_data['rep_link_full_acc']
    expect(subject.completed_on).to eq assessment_data['completed']
    expect(subject.expires_on).to eq assessment_data['expires']
    expect(subject.started_on).to eq assessment_data['started']
  end

  context 'when given fields attribute' do
    subject do
      described_class.new('application_id' => assessment_data['application_id'], 'app_link_full' => assessment_data['app_link_full'],
                          'fields' => [{ 'app_full_name' => 'James Bond' }, { 'email' => '007@jbond.com' }, { 'other' => 'value' }])
    end

    it 'should have a candidate object with name and email' do
      expect(subject.candidate).to be_a PopEngine::Candidate
      expect(subject.candidate.name).to eq 'James Bond'
      expect(subject.candidate.email).to eq '007@jbond.com'
      expect(subject.candidate.other).to be_nil
    end

    it 'should also have a fields object with all the fields' do
      expect(subject.fields).to be_a PopEngine::CustomFields
      expect(subject.fields.app_full_name).to eq 'James Bond'
      expect(subject.fields.email).to eq '007@jbond.com'
      expect(subject.fields.other).to eq 'value'
    end
  end

  context 'when given answers attribute' do
    let(:answers) { JSON.parse(File.read('spec/fixtures/assessments/scores.json'))['answers'] }

    subject { described_class.new('answers' => answers) }

    it 'should have a collection of answers' do
      expect(subject.answers).to be_a PopEngine::Collection
      expect(subject.answers.first).to be_a PopEngine::Answer
      expect(subject.answers.count).to eq answers.size
    end

    it 'should have the same answer values as the given data' do
      subject.answers.each_with_index do |answer, index|
        expect(answer.q).to eq answers[index]['q']
        expect(answer.a).to eq answers[index]['a']
        expect(answer.c).to eq answers[index]['c']
        expect(answer.t).to eq answers[index]['t']
        expect(answer.v).to eq answers[index]['v']
      end
    end
  end

  context 'when given traits attribute' do
    let(:traits) { JSON.parse(File.read('spec/fixtures/assessments/scores.json'))['traits'] }

    subject { described_class.new('traits' => traits) }

    it 'should have a collection of traits' do
      expect(subject.traits).to be_a PopEngine::Collection
      expect(subject.traits.first).to be_a PopEngine::Trait
      expect(subject.traits.count).to eq traits.size
    end

    it 'should have the same trait values as the given data' do
      subject.traits.each_with_index do |trait, index|
        expect(trait.name).to eq traits[index]['trait_name']
        expect(trait.score).to eq traits[index]['score']
        expect(trait.title_tr).to eq traits[index]['caption_tr']
      end
    end
  end

  context 'when given super_traits attribute' do
    let(:super_traits) { JSON.parse(File.read('spec/fixtures/assessments/scores.json'))['super_traits'] }

    subject { described_class.new('super_traits' => super_traits) }

    it 'should have a collection of super traits' do
      expect(subject.super_traits).to be_a PopEngine::Collection
      expect(subject.super_traits.first).to be_a PopEngine::SuperTrait
      expect(subject.super_traits.count).to eq super_traits.size
    end

    it 'should have the same super trait values as the given data' do
      subject.super_traits.each_with_index do |super_trait, index|
        expect(super_trait.name).to eq super_traits[index]['trait_name']
        expect(super_trait.score).to eq super_traits[index]['score']
        expect(super_trait.title_tr).to eq super_traits[index]['caption_tr']
      end
    end
  end

  context 'when given position_reducers attribute' do
    let(:reducers) { JSON.parse(File.read('spec/fixtures/assessments/scores.json'))['position_reducers'] }

    subject { described_class.new('position_reducers' => reducers) }

    it 'should have a collection of reducers' do
      expect(subject.reducers).to be_a PopEngine::Collection
      expect(subject.reducers.first).to be_a PopEngine::Reducer
      expect(subject.reducers.count).to eq reducers.size
    end

    it 'should have the same reducer values as the given data' do
      subject.reducers.each_with_index do |reducer, index|
        expect(reducer.name).to eq reducers[index]['aname']
        expect(reducer.title_tr).to eq reducers[index]['caption_tr_rdc']
        expect(reducer.eps).to eq reducers[index]['eps']
        expect(reducer.score).to eq reducers[index]['score']
        expect(reducer.score_final).to eq reducers[index]['score_final']
        expect(reducer.score_text).to eq reducers[index]['score_text']
        expect(reducer.value).to eq reducers[index]['avalue']
        expect(reducer.score_text_tr).to eq reducers[index]['caption_tr_score']
        expect(reducer.trait_name).to eq reducers[index]['trait_name']
      end
    end
  end
end
