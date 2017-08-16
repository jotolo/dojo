module Api
  class HeroResource < JSONAPI::Resource
    has_many :abilities
  end
end
