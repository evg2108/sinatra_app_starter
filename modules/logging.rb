module Logging
  def log_error(message)
    add_to_log(message, :error)
  end

  def log_info(message)
    add_to_log(message, :info)
  end

  def log_debug(message)
    add_to_log(message, :debug)
  end

  def log_warning(message)
    add_to_log(message, :warning)
  end

  def add_to_log(message, level)
    if @logger
      @logger.send(level, message)
    end
  end
end