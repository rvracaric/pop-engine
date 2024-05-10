require 'spec_helper'

RSpec.describe PopEngine::Reducer do
  let(:reducer_data) do
    {
      'aname' => 'overall_stoplight',
      'caption_tr_rdc' => 'OVERALL PREVIEW',
      'eps' => 1,
      'score' => 3,
      'score_final' => 2,
      'score_text' => 'Proceed with Caution',
      'avalue' => 2,
      'caption_tr_score' => 'Proceed with Caution',
      'trait_name' => 'dummy position trait'
    }
  end

  subject { described_class.new(reducer_data) }

  it 'should have the given attributes' do
    expect(subject.aname).to eq reducer_data['aname']
    expect(subject.caption_tr_rdc).to eq reducer_data['caption_tr_rdc']
    expect(subject.eps).to eq reducer_data['eps']
    expect(subject.score).to eq reducer_data['score']
    expect(subject.score_final).to eq reducer_data['score_final']
    expect(subject.score_text).to eq reducer_data['score_text']
    expect(subject.avalue).to eq reducer_data['avalue']
    expect(subject.caption_tr_score).to eq reducer_data['caption_tr_score']
    expect(subject.trait_name).to eq reducer_data['trait_name']
  end

  it 'should have the aliased attributes as well' do
    expect(subject.name).to eq reducer_data['aname']
    expect(subject.title_tr).to eq reducer_data['caption_tr_rdc']
    expect(subject.value).to eq reducer_data['avalue']
    expect(subject.score_text_tr).to eq reducer_data['caption_tr_score']
  end
end
