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

  describe '#list_by_family' do
    let(:stub) do
      stub_request(response: stub_response(fixture: 'assessment_types/list_by_family'),
                   body: { command: 'position_get', partner_api: true, extra_info: true, cmd_ver: 1 })
    end

    it 'should return a collection of assessment families' do
      families = subject.list_by_family

      expect(families).to be_a PopEngine::Collection
      expect(families.count).to eq 2
      expect(families.from_command).to eq 'position_get'

      family = families.first
      expect(family).to be_a PopEngine::AssessmentFamily
      expect(family.id).to eq '101'
      expect(family.name).to eq 'CCS2'
      expect(family.title).to eq 'ContactCenterScreen2.0&trade;'
      expect(family.report_id).to eq family.id
      expect(family.languages).to eq %w[eng spa]
      expect(family.deactivated).to eq false
      expect(family.credits_left).to eq '1000000000'

      expect(family.positions).to be_a PopEngine::Collection
      expect(family.positions.count).to eq 1

      position = family.positions.first
      expect(position).to be_a PopEngine::AssessmentType
      expect(position.id).to eq '201'
      expect(position.name).to eq 'CCS2 Screening Tool'
      expect(position.caption_tr).to eq '0'
      expect(position.title).to eq ''

      expect(families.to_a.last.positions.count).to eq 2
      expect(families.to_a.last.positions.map(&:title)).to eq ['Sales', 'Sales Management']
    end
  end
end
