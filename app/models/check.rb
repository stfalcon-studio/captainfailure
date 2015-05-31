class Check < ActiveRecord::Base
  enum check_type: { icmp: 0, port_open: 1, http_code: 2, http_keyword: 3 }
  enum check_via:  { ip: 0, domain: 1 }

  validates :check_via, presence: true
  validates_numericality_of :tcp_port, greater_than: 0, less_than: 65535, allow_nil: true
  validates_numericality_of :http_code, allow_nil: true

  belongs_to :server

  before_save do |check|
    unless check.check_type == 'icmp'
      raise_save_error(check, 'TCP port required.') if check.tcp_port == nil
    end
    if (check.check_type == 'http_code') or (check.check_type == 'http_keyword')
      check.errors[:base] << 'HTTP code required.' if check.http_code == nil
      self.errors[:base] << 'HTTP vhost required.' if check.http_vhost == nil
    end
    if check.check_type == 'http_keyword'
      check.errors[:base] << 'HTTP keyword required.' if check.http_keyword == nil
    end

    #validates :tcp_port,     presence: true, unless: check_type == 'icmp'
    #validates :http_vhost,   presence: true, if: (check_type == 'http_code') or (check_type == 'http_keyword')
    #validates :http_code,    presence: true, if: (check_type == 'http_code') or (check_type == 'http_keyword')
    #validates :http_keyword, presence: true, if: (check_type == 'http_keyword')
  #   if check.check_type == 1
  #     validates :tcp_port, presence: true
  #   elsif check.check_type == 2
  #     validates :tcp_port,  presence: true
  #     validates :http_code, presence: true
  #   elsif check.check_type == 3
  #     validates :tcp_port,     presence: true
  #     validates :http_code,    presence: true
  #     validates :http_keyword, presence: true
  #     validates :http_vhost,   presence: true
  #   end
  end

  private

  def raise_save_error(check, text)
    check.errors[:base] << text
    raise ActiveRecord::RecordInvalid.new(self)
  end

end
