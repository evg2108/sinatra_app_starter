RSpec.describe RootController do
  describe 'GET /' do
    it 'return "hello" text' do
      get '/'
      expect(last_response.body).to eq('hello')
    end
  end
end