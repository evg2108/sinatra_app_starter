class ClientStrategy < BaseStrategy
  attr_reader :client_id

  def initialize(agent, options)
    @client_id = options.delete('client_id')
    super(agent, options)
  end

  def get_result
    Client.find(client_id)
  end
end