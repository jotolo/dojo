class Hero < ApplicationRecord
  validates_presence_of :name, :real_name, :health, :armour, :shield
  has_many :abilities
end
