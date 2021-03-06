require 'rails_helper'

RSpec.describe 'Jobs API', type: :request do
    let(:user) { create(:user) }
    let!(:jobs) { create_list(:job, 5) }
    let(:job_id) { jobs.first.id }
    let(:headers) { valid_headers }
    

    #List all Jobs
    describe 'GET /jobs' do
        
      before { get '/jobs' , params: {}, headers: headers}
      it 'returns jobs' do
        expect(json).not_to be_empty
        expect(json.size).to eq(5)
    end

    it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    # Get specefic job
    describe 'GET /jobs/:id' do
        before { get "/jobs/#{job_id}", params: {}, headers: headers }
        context 'when the record exists' do
            it 'returns the job' do
              expect(json).not_to be_empty
              expect(json['id']).to eq(job_id)
            end
            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end
         end

    context 'when the record does not exist' do
        let(:job_id) { 100 }
        it 'returns status code 404' do
            expect(response).to have_http_status(404)
        end
        it 'returns a not found message' do
            expect(response.body).to match(/Couldn't find Job/)
          end
        end
    end
    
    # add new job POST request
    describe 'POST /jobs' do
        let(:valid_attributes) { { title: 'Full-Stack Developer', desc:'High passion in programming' }.to_json }
        context 'when the request is valid' do
            before { post '/jobs', params: valid_attributes, headers: headers }
            it 'creates a job' do
                expect(json['title']).to eq('Full-Stack Developer')
            end
            it 'returns status code 201' do
                expect(response).to have_http_status(201)
            end
        end
        context 'when the request is invalid' do
            before { post '/jobs', params: { title: 'Front-End' }.to_json ,headers: headers}
      
            it 'returns status code 422' do
              expect(response).to have_http_status(422)
            end
            it 'returns a validation failure message' do
                expect(response.body)
                  .to match(/Validation failed: Desc can't be blank/)
            end
        end
    end

    # update specefic JOB
    describe 'PUT /jobs/:id' do
        let(:valid_attributes) { { title: 'Backend Developer' }.to_json }
    
        context 'when the record exists' do
          before { put "/jobs/#{job_id}", params: valid_attributes, headers: headers}
    
          it 'updates the record' do
            expect(response.body).to be_empty
          end
    
          it 'returns status code 204' do
            expect(response).to have_http_status(204)
          end
        end
    end

    # Delete specefic JOB
    describe 'DELETE /jobs/:id' do
        before { delete "/jobs/#{job_id}" , params: {}, headers: headers}
    
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
end

   