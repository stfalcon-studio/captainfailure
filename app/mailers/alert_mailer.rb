class AlertMailer < ApplicationMailer
  default :from => Rails.configuration.email_from

  def send_alert(address, check_type, server, text)
    @text = text
    mail( :to => address,
          :subject => "[#{server}][#{check_type}] FAILED!" ) do |format|
      format.text
    end
  end
end