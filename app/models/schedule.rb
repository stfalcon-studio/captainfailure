class Schedule < ActiveRecord::Base
  belongs_to :schedulable, polymorphic: true
  validates :m, :h, :dom, :mon, :dow, presence: true
end
