class Satellite < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true, length: {
                     maximum: 1,
                     tokenizer: lambda { |str| str.split(/\s+/) },
                     too_long: "Please choose a name that is only %{count} word."
                 }
end
