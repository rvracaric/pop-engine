require 'spec_helper'

RSpec.describe PopEngine::AssessmentFamily do
  let(:assessment_family_data) do
    {
      'report_id' => '102',
      'report_name' => 'EPOP',
      'deactivated' => false,
      'report_title' => 'ExpressPOP&trade;',
      'rep_cust' => '',
      'lang_list' => 'eng,fre,spa',
      'credits_left' => '1000000000',
      'positions' => [
        {
          'position_id' => '202',
          'aname' => 'EPOP™ Sales',
          'caption_tr' => '301',
          'title' => 'Sales'
        },
        {
          'position_id' => '203',
          'aname' => 'EPOP™ Sales Management',
          'caption_tr' => '302',
          'title' => 'Sales Management'
        }
      ]
    }
  end

  subject { described_class.new(assessment_family_data) }

  it 'should have the given assessment family data' do
    expect(subject.report_id).to eq assessment_family_data['report_id']
    expect(subject.report_name).to eq assessment_family_data['report_name']
    expect(subject.report_title).to eq assessment_family_data['report_title']
    expect(subject.deactivated).to eq assessment_family_data['deactivated']
    expect(subject.rep_cust).to eq assessment_family_data['rep_cust']
    expect(subject.lang_list).to eq assessment_family_data['lang_list']
    expect(subject.credits_left).to eq assessment_family_data['credits_left']
  end

  it 'should have the aliased attribs as well' do
    expect(subject.id).to eq subject.report_id
    expect(subject.name).to eq subject.report_name
    expect(subject.title).to eq subject.report_title
    expect(subject.assessment_types).to equal subject.positions
  end

  it 'should split lang_list into languages' do
    expect(subject.languages).to eq %w[eng fre spa]
  end

  it 'should return an empty language list when lang_list is blank' do
    expect(described_class.new('lang_list' => '').languages).to eq []
    expect(described_class.new({}).languages).to eq []
  end

  it 'should wrap positions in a collection of assessment types' do
    expect(subject.positions).to be_a PopEngine::Collection
    expect(subject.positions.count).to eq 2
    expect(subject.positions.first).to be_a PopEngine::AssessmentType
    expect(subject.positions.first.id).to eq '202'
    expect(subject.positions.first.name).to eq 'EPOP™ Sales'
    expect(subject.positions.first.caption_tr).to eq '301'
    expect(subject.positions.first.title).to eq 'Sales'
  end
end
