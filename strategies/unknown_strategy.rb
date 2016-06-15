class UnknownStrategy < BaseStrategy
  def initialize(agent, options)
    @strategy_name = options.delete(:strategy_name)
    super(agent, options)
  end

  def get_result
    raise UnknownStrategyError, "Unknown strategy: '#{@strategy_name}'"
  end
end

class UnknownStrategyError < StandardError; end
