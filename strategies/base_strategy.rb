######################################################
#                                                    #
# In strategies you must implement get_result method #
#                                                    #
######################################################
class BaseStrategy
  include Logging

  attr_reader :agent, :result, :redis, :branch

  def initialize(agent, options)
    @agent = agent
    @options = Hash(options)
    @redis = @options.delete(:redis)
    @logger = @options.delete(:logger)
    @branch = @options.delete(:branch)
  end

  def process
    process!
  rescue StandardError => ex
    log_error(ex.message + "\n" + ex.backtrace.join("\n"))
  end

  def process!
    @result = get_result
  end

  def get_result
    raise NotImplementedError, "Please implement #{strategy_name}#get_result method"
  end

  def strategy_name
    self.class.name
  end

  def strategy_obsolete
    raise StrategyObsoleteError, "#{strategy_name.demodulize.titleize} is obsolete"
  end
end

class StrategyObsoleteError < StandardError; end