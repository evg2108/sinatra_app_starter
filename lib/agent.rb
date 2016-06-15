class Agent
  include Logging

  attr_reader :agent, :redis, :branch

  delegate :get, :post, :page, :cookie_jar, to: :agent

  def initialize(options = nil)
    @options = Hash(options)
    @redis = @options.delete(:redis)
    @logger = @options.delete(:logger)
    @branch = @options.delete(:branch)
    configure_agent
  end

  def configure_agent
    @agent = Mechanize.new
    agent.user_agent_alias = 'Linux Mozilla'
    agent.redirect_ok = true
    agent.read_timeout = 60
    agent.ssl_version = 'TLSv1'
    agent.log = @logger if @logger
  end

  def save_cookies(login)
    buffer = StringIO.new
    agent.cookie_jar.save buffer, session: true
    buffer.rewind
    redis.set("cookie_#{branch}_#{login}", buffer.read)
  end

  def load_cookies(login)
    buffer = StringIO.new
    buffer.write redis.get("cookie_#{branch}_#{login}")
    buffer.rewind
    agent.cookie_jar.load(buffer, session: true) unless buffer.length.zero?
  end

end