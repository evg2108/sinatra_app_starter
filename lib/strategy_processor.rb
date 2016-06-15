class StrategyProcessor
  include Logging

  attr_reader :session_id, :logger, :login, :branch, :redis

  def initialize(branch, login, options = {})
    @options = options
    @redis = @options.delete(:redis)
    @logger = @options.delete(:logger)
    @branch = branch
    @login = login
    clear!
  end

  def sign_in(password)
    strategy = execute(:sign_in, false, login: login, password: password)
    @session_id = strategy.session_id
    strategy.result
  end

  def process(strategy_name, options = {})
    strategy = execute(strategy_name, true, options.merge(session_id: session_id))
    strategy.result
  end

  def clear!
    @strategies = {}
  end

  def get_results
    result = {}
    other = {}
    @strategies.each do |strategy_name, strategy_info|
      if strategy_info[:is_main]
        result[strategy_name] = strategy_info[:strategy].result
      else
        other[strategy_name] = strategy_info[:strategy].result
      end
    end
    result[:other] = other if other.any?
    result
  end

  def agent
    @agent ||= Agent.new(redis: redis, logger: logger, branch: branch)
  end

  private

  def execute(strategy_name, is_main_strategy, options = {})
    strategy = get_strategy(strategy_name, options.merge(branch: branch))
    strategy.process
    @strategies[strategy_name.to_s] = { strategy: strategy, is_main: is_main_strategy }
    strategy
  end

  def get_strategy(strategy_name, options = {})
    strategy_class = "#{strategy_name.to_s.camelcase}Strategy".safe_constantize
    if strategy_class
      strategy_class.new(agent, options.merge(logger: logger))
    else
      UnknownStrategy.new(agent, options.merge(strategy_name: strategy_name))
    end
  end
end
