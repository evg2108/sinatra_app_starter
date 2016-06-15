require 'bundler/setup'
require 'sinatra'
require 'sinatra/jbuilder'
require 'sinatra/router'
require 'json'
require 'sinatra/param'
require 'mechanize'
require 'redis'
require 'sinatra/config_file'

require 'pry-byebug' if development? && !ENV['WITHOUT_DEBUG']

files_for_load = []
files_for_load += Dir['./modules/*.rb'] # Вспомогательные модули
files_for_load += Dir['./configuration.rb'] # Конфигурация приложения
files_for_load += Dir['./models/*.rb'] # модели
files_for_load += Dir['./strategies/base_strategy.rb'] | Dir['./strategies/*_strategy.rb'] # Стратегии
files_for_load += Dir['./lib/agent.rb'] # агент
files_for_load += Dir['./lib/strategy_processor.rb'] # процессор (обработчик стратегий)
files_for_load += Dir['./lib/application_service.rb'] # командный центр
files_for_load += Dir['./controllers/application_controller.rb'] | Dir['./controllers/*_controller.rb'] # контроллеры
files_for_load += Dir['./routes.rb'] # маршруты
files_for_load.map { |path| require path }