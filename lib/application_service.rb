class ApplicationService
  include Logging

  def initialize(options = nil)
    @options = Hash(options)
    @redis = @options.delete(:redis)
    @logger = @options.delete(:logger)
    @accounts = {}
  end

  def collect_info(options = {})
    branch = options.delete('branch')
    login = options.delete('login')
    password = options.delete('pass')
    @accounts[branch] ||= {}
    @accounts[branch][login] ||= StrategyProcessor.new(branch, login, redis: @redis, logger: @logger)
    current_account = @accounts[branch][login]
    current_account.clear!

    strategies = options.delete(:strategies)

    if strategies.any?
      if current_account.sign_in(password)
        strategies.each do |strategy_name|
          current_account.process(strategy_name, options)
        end
      end
    end

    current_account.get_results
  end
end
