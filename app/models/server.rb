class Server < ActiveRecord::Base
  validates :dns_name, presence: true, uniqueness: true
  validates :ip_address, presence: true, format: { :with => Resolv::IPv4::Regex }

  def resolv_ip
    begin
      self.ip_address = Socket::getaddrinfo(self.dns_name, Socket::SOCK_STREAM)[0][3]
    rescue SocketError
      self.ip_address = ''
      self.errors[:base] << 'Can\'t resolve DNS name. Please, enter IP address manually.'
    end
  end

end
