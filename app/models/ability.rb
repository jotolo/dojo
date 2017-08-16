class Ability < ApplicationRecord
  validates_presence_of :name
  belongs_to :hero
end
