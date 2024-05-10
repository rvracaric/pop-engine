require 'spec_helper'

RSpec.describe PopEngine::Client do
  let(:username) { 'jbond' }
  let(:password) { '007' }

  subject { described_class.new(username: username, password: password) }

  it 'should have the given username' do
    expect(subject.username).to eq username
  end

  it 'should have the given password' do
    expect(subject.password).to eq password
  end

  it 'should have the default Faraday adapter when none given' do
    expect(subject.adapter).to eq(Faraday.default_adapter)
  end

  it 'should have the default language id when none given' do
    expect(subject.language_id).to eq(described_class::DEFAULT_LANGUAGE_ID)
  end

  context 'when given an adapter' do
    subject { described_class.new(username: username, password: password, adapter: :typhoeus) }

    it 'should have the given adapter' do
      expect(subject.adapter).to eq(:typhoeus)
    end
  end

  context 'when given a language id' do
    let(:language_id) { 'fra' }
    subject { described_class.new(username: username, password: password, language_id: language_id) }

    it 'should have the given language id' do
      expect(subject.language_id).to eq(language_id)
    end
  end

  it 'should raise an error when not given username' do
    expect { described_class.new(password: password) }.to raise_error(ArgumentError)
  end

  it 'should raise an error when not given password' do
    expect { described_class.new(username: username) }.to raise_error(ArgumentError)
  end
end
