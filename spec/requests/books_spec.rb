require 'rails_helper'

RSpec.describe 'Books API', type: :request do
  let(:title) { "of+mice+and+men" }
  let(:isbn) { "0142000671" }

  #Test suite for GET /books
  describe 'GET /book' do

    it 'returns empty when there are no parameter' do
      get '/book'
      # Note `json` is a custom helper to parse JSON responses
      expect(json).to be_empty
    end

    it 'returns status code 200' do
      get '/book'
      expect(response).to have_http_status(200)
    end

    it 'return books when title parameter exist' do
      get "/book?title=#{title}"

      expect(response).to have_http_status(200)
      expect(json).not_to be_empty
      expect(json.size).to be > 0
    end

    it 'return book when isbn parameter exist' do
      get "/book?isbn=#{isbn}"

      expect(response).to have_http_status(200)
      expect(json).not_to be_empty
      expect(json.size).to be 1
    end
  end
end