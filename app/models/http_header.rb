class HttpHeader < ActiveRecord::Base
  belongs_to :check

  validates :name, :value, presence: true
end
