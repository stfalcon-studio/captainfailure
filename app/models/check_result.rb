class CheckResult < ActiveRecord::Base
  serialize :satellites_data, Array
  belongs_to :server
  belongs_to :check
end
