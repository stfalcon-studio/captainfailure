class RegistrationMailer < ApplicationMailer
  default :from => Rails.configuration.email_from

  def send_info(address, app_host, password)
    @address = address
    @app_host = app_host
    @password = password
    mail( :to => address,
          :subject => "You got account on #{app_host.split('//')[1]}" ) do |format|
      format.html
    end
  end
end
