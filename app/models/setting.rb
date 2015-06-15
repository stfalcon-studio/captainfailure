class Setting < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :value, presence: true
  serialize :value, Hash

  def method_missing(method_name, *arg)
    if method_name.to_s.last == '='
      key = method_name.to_s.split('=')[0].to_sym
      self.value[key] = arg[0]
    else
      self.value[method_name]
    end
  end
end
