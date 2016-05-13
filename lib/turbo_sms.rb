require 'savon'

class TurboSms
  def initialize(opts)
    @opts = opts
    @client = Savon.client(wsdl: 'http://turbosms.in.ua/api/wsdl.html')
    auth
  end

  def balance
    responce = @client.call(:get_credit_balance, cookies: @session)
    responce.body[:get_credit_balance_response][:get_credit_balance_result].to_i
  end

  def send_sms(number, text)
    @client.call(:send_sms, message: { sender: @opts[:sender], text: text, destination: number }, cookies: @session)
  end

  private

  def auth
    response = @client.call(:auth, message: { login: @opts[:login], password: @opts[:password] })
    if response.body[:auth_response][:auth_result] == 'Вы успешно авторизировались'
      @session = response.http.cookies
    else
      raise AuthError
    end
  end

  class AuthError < StandardError
    attr_reader :reason
    def initialize
      @reason = 'Auth error'
    end
  end
end