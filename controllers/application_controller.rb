class ApplicationController < Sinatra::Base
  before do
    content_type :json, charset: 'utf-8'
    define_common_params
    define_params
  end

  def define_common_params
    param :branch, String, required: true
    param :login, String, required: true
    param :pass, String, required: true
  end

  # stub for redefine
  def define_params; end

  def service
    @service ||= ApplicationService.new(redis: options.redis, logger: logger)
  end

  error InvalidParameterError do
    error = env['sinatra.error']
    error_message = "#{error.message}: #{error.param}"
    @status = :error
    @data_array = [code: :parameter_error, message: error_message]
    jbuilder :error
  end

  error do
    error = env['sinatra.error']
    error_message = error.message
    @status = :error
    @data_array = [code: :unhandled_server_error, message: error_message]
    jbuilder :error
  end
end