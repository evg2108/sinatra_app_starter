class ClientController < ApplicationController
  get '/client' do
    @status = :ok
    result = service.collect_info(params.merge(strategies: [:client]))
    @data_array = result['client']
    jbuilder :data
  end

  def define_params
    param :client_id, Integer, required: true
  end
end