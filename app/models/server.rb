class Server < ActiveRecord::Base
  validates :dns_name, presence: true, uniqueness: true
  validates :ip_address, presence: true, format: { :with => Resolv::IPv4::Regex }
end
