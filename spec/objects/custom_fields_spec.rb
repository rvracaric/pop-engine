require 'spec_helper'

RSpec.describe PopEngine::CustomFields do
  subject { described_class.new(fields) }

  shared_examples_for 'a custom field object' do
    it 'should have the given fields' do
      expect(subject.app_full_name).to eq 'James Bond'
      expect(subject.email).to eq '007@jbond.com'
      expect(subject.other).to eq 'value'
    end
  end

  context 'when given an array of hashes' do
    let(:fields) do
      [
        { 'app_full_name' => 'James Bond' },
        { 'email' => '007@jbond.com' },
        { 'other' => 'value' }
      ]
    end

    it_behaves_like 'a custom field object'
  end

  context 'when given a hash' do
    let(:fields) do
      {
        'app_full_name' => 'James Bond',
        'email' => '007@jbond.com',
        'other' => 'value'
      }
    end

    it_behaves_like 'a custom field object'
  end

  context 'when given a pipe-separated config string' do
    let(:fields) { 'app_full_name|James Bond|email|007@jbond.com|other|value' }

    it_behaves_like 'a custom field object'
  end
end
