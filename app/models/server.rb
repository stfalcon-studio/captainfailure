# Copyright 2015 Evgeniy Gurinovich
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class Server < ActiveRecord::Base
  validates :dns_name, presence: true, uniqueness: true
  validates :ip_address, presence: true, format: { :with => Resolv::IPv4::Regex }
  enum alert_on: { 'All satellites failed': 0, 'One satellite failed': 1 }
  has_and_belongs_to_many :satellites
  has_many :check_results
  has_many :server_notifications
  has_many :checks
  accepts_nested_attributes_for :checks
  has_many :notifications, through: :server_notifications

  before_destroy do |server|
    server.checks.all.each { |check| check.destroy }
    ServerNotification.where(server_id: server.id).each { |server_notification| server_notification.delete }
  end

  def resolv_ip
    begin
      self.ip_address = Socket::getaddrinfo(self.dns_name, Socket::SOCK_STREAM)[0][3]
    rescue SocketError
      self.ip_address = ''
      self.errors[:base] << 'Can\'t resolve DNS name. Please, enter IP address manually.'
    end
  end

end
