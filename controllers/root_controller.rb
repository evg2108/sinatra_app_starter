class RootController < Sinatra::Base
  get '/' do
    [200, {}, 'hello']
  end
end