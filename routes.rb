use Sinatra::Router do
  mount RootController
  mount ClientController
end