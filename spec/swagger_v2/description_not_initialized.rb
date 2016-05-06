require 'spec_helper'

describe 'details' do
  describe 'details, pass markdown with redcarpet even with nil description and detail', unless: RUBY_PLATFORM.eql?('java') do
    include_context 'the api entities'

    before :all do
      module TheApi
        class GfmRcDetailApi < Grape::API
          format :json

          desc nil,
               detail: nil,
               entity: Entities::UseResponse,
               failure: [{ code: 400, model: Entities::ApiError }]
          get '/use_gfm_rc_detail' do
            { 'declared_params' => declared(params) }
          end

          add_swagger_documentation markdown: GrapeSwagger::Markdown::RedcarpetAdapter.new
        end
      end
    end

    def app
      TheApi::GfmRcDetailApi
    end

    subject do
      get '/swagger_doc'
      JSON.parse(last_response.body)
    end

    specify do
      expect(subject['paths']['/use_gfm_rc_detail']['get']).not_to include('description')
      expect(subject['paths']['/use_gfm_rc_detail']['get']['description']).to eql(nil)
    end
  end
end
