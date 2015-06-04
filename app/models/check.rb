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

class Check < ActiveRecord::Base
  enum check_type:    { icmp: 0, port_open: 1, http_code: 2, http_keyword: 3 }
  enum check_via:     { ip: 0, domain: 1 }
  enum http_protocol: { http: 0, https: 1 }
  enum enabled:       {yes: true, no: false}

  validates :check_via, presence: true
  validates_numericality_of :tcp_port, greater_than: 0, less_than: 65535, allow_nil: true
  validates_numericality_of :http_code, allow_nil: true

  belongs_to :server

  before_save do |check|
    unless check.check_type == 'icmp'
      raise_save_error(check, 'TCP port required.') if check.tcp_port == nil
    end
    if (check.check_type == 'http_code') or (check.check_type == 'http_keyword')
      raise_save_error(check, 'HTTP code required.') if check.http_code == nil
      raise_save_error(check, 'HTTP vhost required.') if check.http_vhost == ''
      raise_save_error(check, 'HTTP uri required.') if check.http_uri == ''
      raise_save_error(check, 'HTTP protocol required.') if check.http_protocol == nil
    end
    if check.check_type == 'http_keyword'
      raise_save_error(check, 'HTTP keyword required.') if check.http_keyword == ''
    end

  end

  private

  def raise_save_error(check, text)
    check.errors[:base] << text
    raise ActiveRecord::RecordInvalid.new(self)
  end

end
