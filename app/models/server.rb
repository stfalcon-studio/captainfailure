class Server < ActiveRecord::Base
  validates :visible_name, presence: true, uniqueness: true
  validates :ip_address, presence: true, uniqueness: true, format: { :with => Resolv::IPv4::Regex }
end
