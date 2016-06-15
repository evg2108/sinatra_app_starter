class SignInStrategy < BaseStrategy
  COOKIE_LOGIN_KEY = 'last_user_login:dealer.megafonsib.ru'
  COOKIE_SESSION_ID_KEY = 'sbms-shell-session-id:dealer.megafonsib.ru'

  attr_reader :login, :password, :session_id

  def initialize(agent, options)
    @login = options.delete(:login)
    @password = options.delete(:password)
    super(agent, options)
  end

  def get_result
    if authenticated?
      log_info("AUTHENTICATION TEST: #{login} already authenticated, session_id: #{@session_id}")
      success
    else
      log_info("AUTHENTICATION TEST: #{login} start authentication")
      authenticate
    end
  end

  private

  def success
    'ok'
  end

  def save_cookie
    agent.save_cookies(login)
  end

  def authenticate
    successful_auth = true

    if successful_auth
      save_cookie
      success
    else
      user_found = true
      password_valid = true

      fail(UserNotFoundError, 'Unauthorized: user not found') unless user_found
      fail(WrongPasswordError, 'Unauthorized: wrong password') unless password_valid

      fail(AuthorizationError, "Unauthorized: unhandled authorization error")
    end
  end

  def authenticated?
    true
  end
end

class AuthorizationError < StandardError; end
class UserNotFoundError < AuthorizationError; end
class WrongPasswordError < AuthorizationError; end
