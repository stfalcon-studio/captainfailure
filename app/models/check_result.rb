class CheckResult < ActiveRecord::Base
  serialize :satellites_data, Hash
  belongs_to :server
  belongs_to :check
end
