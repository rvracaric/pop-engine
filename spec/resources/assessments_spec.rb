require 'spec_helper'
require 'json'
require 'support/stub_api_call'

RSpec.describe PopEngine::AssessmentsResource do
  let(:assessment_type_id) { 12 }
  let(:candidate_email) { '007@jbond.com' }
  let(:candidate_name) { 'James Bond' }
  let(:language_id) { PopEngine::Client::DEFAULT_LANGUAGE_ID }
  let(:client) { PopEngine::Client.new(username: 'fake', password: 'fake', adapter: :test, stubs: stub) }
  let(:stub) { stub_request(response: stub_response(fixture: 'assessments/create'), body: request_body) }
  let(:request_body) do
    {
      command: 'application_create',
      partner_api: true,
      language_id: language_id,
      position_id: assessment_type_id,
      fields: custom_fields_for_request_body
    }
  end

  describe '#create' do
    let(:assessment_options) do
      {
        assessment_type_id: assessment_type_id,
        candidate_email: candidate_email,
        candidate_name: candidate_name,
        fields: custom_fields
      }
    end

    let(:custom_fields) do
      {
        job_application_id: '32123',
        business_unit_id: '876'
      }
    end

    let(:custom_fields_for_request_body) do
      custom_fields.merge(email: candidate_email, app_full_name: candidate_name).map{ |k, v| { n: k, v: v } }
    end

    let(:response_data) { JSON.parse(File.read('spec/fixtures/assessments/create.json')) }

    subject { client.assessments.create(assessment_options) }

    it 'should return an assessment object' do
      expect(subject).to be_a PopEngine::Assessment
    end

    it 'should return an assessment object with the correct attributes' do
      expect(subject).to have_attributes(
        id: response_data['application_id'],
        url: response_data['app_link_full']
      )
    end

    context 'when language_id given' do
      let(:language_id) { 'fra' }
      let(:assessment_options) do
        {
          candidate_email: candidate_email,
          candidate_name: candidate_name,
          language_id: language_id,
          fields: custom_fields,
          assessment_type_id: assessment_type_id
        }
      end

      before do
        assessment_options.merge!(language_id: language_id)
      end

      it 'should create the assessment' do
        expect(subject).to be_a PopEngine::Assessment
      end
    end

    context 'when position_id is given' do
      let(:position_id) { 123 }
      let(:request_body) do
        {
          command: 'application_create',
          partner_api: true,
          position_id: assessment_type_id,
          language_id: language_id,
          fields: custom_fields_for_request_body
        }
      end

      before do
        assessment_options.merge!(position_id: position_id)
        assessment_options.delete(:assessment_type_id)
        request_body[:position_id] = position_id
      end

      it 'should create the assessment' do
        expect(subject).to be_a PopEngine::Assessment
      end
    end

    context 'when candidate email and name are given in fields hash with friendly aliases' do
      let(:assessment_options) do
        {
          assessment_type_id: assessment_type_id,
          fields: { candidate_email: candidate_email, candidate_name: candidate_name }
        }
      end
      let(:custom_fields) do
        {}
      end

      it 'should create the assessment' do
        expect(subject).to be_a PopEngine::Assessment
      end
    end

    context 'when candidate email and name are given in the original field names' do
      let(:assessment_options) do
        {
          assessment_type_id: assessment_type_id,
          fields: { email: candidate_email, app_full_name: candidate_name }
        }
      end
      let(:custom_fields) do
        {}
      end

      it 'should create the assessment' do
        expect(subject).to be_a PopEngine::Assessment
      end
    end
  end

  describe '#list' do
    let(:response_data) { JSON.parse(File.read('spec/fixtures/assessments/list.json'))['application_list'].first }
    let(:stub) { stub_request(response: stub_response(fixture: 'assessments/list'),
                              body: { command: 'application_get', partner_api: true }) }

    subject { client.assessments.list }

    it 'should return a collection of assessment objects' do
      expect(subject).to be_a PopEngine::Collection
      expect(subject.first).to be_a PopEngine::Assessment
      expect(subject.count).to eq 3
      expect(subject.next_cursor).to be_nil
    end

    it 'should return a collection of assessment objects with the correct attributes' do
      expect(subject.first).to have_attributes(
                                 application_id: response_data['application_id'],
                                 converted_from: response_data['converted_from'],
                                 account_id: response_data['account_id'],
                                 position_id: response_data['position_id'],
                                 position: response_data['position'],
                                 max_count: response_data['max_count'],
                                 has_followup: response_data['has_followup'],
                                 is_reusable: response_data['is_reusable'],
                                 date_exp: response_data['date_exp'],
                                 date_sub: response_data['date_sub'],
                                 url: response_data['app_link_full'],
                                 completed: response_data['completed'],
                                 expires: response_data['expires'],
                                 started: response_data['started'],
                                 candidate: an_instance_of(PopEngine::Candidate),
                                 fields: an_instance_of(PopEngine::CustomFields))
    end

    it 'should return a collection of assessment objects with the aliased attributes as well' do
      expect(subject.first).to have_attributes(
                                 id: response_data['application_id'],
                                 type_id: response_data['position_id'],
                                 type_name: response_data['position'],
                                 url: response_data['app_link_full'],
                                 expires_on: response_data['expires'],
                                 started_on: response_data['started'],
                                 completed_on: response_data['completed'])
    end

    context 'when additional pages are available' do
      let(:page_1_response_data) { JSON.parse(File.read('spec/fixtures/assessments/list_page_1.json')) }
      let(:page_2_response_data) { JSON.parse(File.read('spec/fixtures/assessments/list_page_2.json')) }

      let(:stub) do
        page_stub = Faraday::Adapter::Test::Stubs.new

        # Stub call for the first page
        page_stub.post(PopEngine::Client::API_URL,
                       { command: 'application_get', partner_api: true, max_count: 2 }.to_json) do
          # Response
          [
            200,
            { 'Content-Type' => 'application/json' },
            File.read('spec/fixtures/assessments/list_page_1.json')
          ]
        end

        # Stub call for the second page
        page_stub.post(PopEngine::Client::API_URL,
                       { command: 'application_get', partner_api: true, max_count: 2,
                         start_date: page_1_response_data['next_date'],
                         start_app_id: page_1_response_data['next_app_id'],
                         start_acc_id: page_1_response_data['next_acc_id']}.to_json) do
          # Response
          [
            200,
            { 'Content-Type' => 'application/json' },
            File.read('spec/fixtures/assessments/list_page_2.json')
          ]
        end

        page_stub
      end

      it 'should return a collection of assessment objects in pages' do
        page_1 = client.assessments.list(per_page: 2)

        expect(page_1).to be_a PopEngine::Collection
        expect(page_1.count).to eq 2
        expect(page_1.first.id).to eq page_1_response_data['application_list'].first['application_id']
        expect(page_1.next_cursor).to eq({ assessment_id: page_1_response_data['next_app_id'],
                                            account_id: page_1_response_data['next_acc_id'],
                                            date: page_1_response_data['next_date'] })

        page_2 = client.assessments.list(per_page: 2,
                                         start_assessment_id: page_1_response_data['next_app_id'],
                                         start_account_id: page_1_response_data['next_acc_id'],
                                         start_date: page_1_response_data['next_date'])

        expect(page_2).to be_a PopEngine::Collection
        expect(page_2.count).to eq 1
        expect(page_2.first.id).to eq page_2_response_data['application_list'].first['application_id']
        expect(page_2.next_cursor).to be_nil
      end
    end
  end

  describe '#retrieve' do
    let(:response_data) { JSON.parse(File.read('spec/fixtures/assessments/retrieve.json')) }
    let(:assessment_id) { response_data['application_id'] }
    let(:stub) { stub_request(response: stub_response(fixture: 'assessments/retrieve'),
                              body: { command: 'application_get', partner_api: true, application_id: assessment_id }) }

    subject { client.assessments.retrieve(assessment_id) }

    it 'should return an assessment object' do
      expect(subject).to be_a PopEngine::Assessment
    end

    it 'should return an assessment object with the correct attributes' do
      expect(subject).to have_attributes(
        id: response_data['application_id'],
        type_id: response_data['position_id'],
        type_name: response_data['position'],
        status: response_data['status'],
        report_url: response_data['rep_link_full'],
        advanced_report_url: response_data['rep_link_full_acc'],
        account_id: response_data['account_id'],
        completed_on: response_data['completed'],
        expires_on: response_data['expires'],
        started_on: response_data['started'],
        candidate: an_instance_of(PopEngine::Candidate),
        fields: an_instance_of(PopEngine::CustomFields)
      )
    end
  end

  describe '#links' do
    let(:assessment_id) { 134 }
    let(:response_data) { JSON.parse(File.read('spec/fixtures/assessments/links.json')) }
    let(:stub) { stub_request(response: stub_response(fixture: 'assessments/links'),
                              body: { command: 'application_get_link', partner_api: true, application_id: assessment_id }) }

    subject { client.assessments.links(assessment_id) }

    it 'should return an assessment object' do
      expect(subject).to be_a PopEngine::Assessment
    end

    it 'should return an assessment object with the correct attributes' do
      expect(subject).to have_attributes(
        id: assessment_id,
        report_url: response_data['rep_link_full'],
        url: response_data['app_link_full']
      )
    end
  end

  describe '#scores' do
    let(:assessment_id) { 134 }
    let(:response_data) { JSON.parse(File.read('spec/fixtures/assessments/scores.json')) }
    let(:request_body) do
      {
        command: 'score_calc_get',
        partner_api: true,
        application_id: assessment_id,
        language_id: PopEngine::Client::DEFAULT_LANGUAGE_ID,
        show_traits: true,
        show_super_traits: true,
        show_reducers: true,
        show_answers: true
      }
    end
    let(:stub) { stub_request(response: stub_response(fixture: 'assessments/scores'), body: request_body) }

    subject { client.assessments.scores(assessment_id) }

    it 'should return an assessment object' do
      expect(subject).to be_a PopEngine::Assessment
    end

    it 'should return an assessment object with original attribute names' do
      expect(subject).to have_attributes(
        application_id: assessment_id,
        rep_link_full: response_data['rep_link_full'],
        language_id: response_data['language_id'],
        report_name: response_data['report_name'],
        report_name_has: response_data['report_name_has'],
        score: response_data['score'],
        score_final: response_data['score_final'],
        score_text: response_data['score_text'],
        main_score_found: response_data['main_score_found'],
        calc_acc_id: response_data['calc_acc_id']
      )
    end

    it 'should return an assessment object with aliased attribute names' do
      expect(subject).to have_attributes(
        id: assessment_id,
        report_url: response_data['rep_link_full']
      )
    end

    it 'should return an assessment object with all optional info by default' do
      expect(subject.answers.first).to be_a PopEngine::Answer
      expect(subject.traits.first).to be_a PopEngine::Trait
      expect(subject.super_traits.first).to be_a PopEngine::SuperTrait
      expect(subject.reducers.first).to be_a PopEngine::Reducer
    end

    context 'when optional info is not requested' do
      let(:request_body) do
        {
          command: 'score_calc_get',
          partner_api: true,
          application_id: assessment_id,
          language_id: PopEngine::Client::DEFAULT_LANGUAGE_ID,
          show_traits: false,
          show_super_traits: false,
          show_reducers: false,
          show_answers: false
        }
      end
      let(:response) do
        {
          error_code: 0,
          error_text: '',
          command_from: 'score_calc_get',
          rep_link_full: 'https://pop.selfmgmt.com/report/link',
          calc_acc_id: '123',
          language_id: 'eng',
          main_score_found: true,
          score: 3,
          score_final: 3,
          score_text: '',
          report_name: 'Report Name',
          report_name_has: true
        }.to_json
      end

      let(:stub) do
        stub_request(response: [200, { 'Content-Type' => 'application/json' }, response], body: request_body)
      end

      subject do
        client.assessments.scores(assessment_id, traits: false, super_traits: false, reducers: false, answers: false)
      end

      it 'should return an assessment object without optional info' do
        expect(subject.answers).to be_nil
        expect(subject.traits).to be_nil
        expect(subject.super_traits).to be_nil
        expect(subject.reducers).to be_nil
      end
    end
  end
end
