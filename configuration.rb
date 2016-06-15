module Sinatra
  class Base
    set :root, File.expand_path(File.dirname(__FILE__))
    set :views, settings.root + '/views'
    disable :show_exceptions

    enable :raise_sinatra_param_exceptions
    enable :logging

    set :redis, Redis.new(db: 1, driver: :hiredis)

    register Sinatra::ConfigFile
    config_file settings.root + '/config/settings.yml'

    helpers Sinatra::Param

    not_found do
      content_type :json, charset: 'utf-8'
      @status = :error
      @data_array = [code: :routing_error, message: 'Путь не найден']
      jbuilder :error
    end
  end
end