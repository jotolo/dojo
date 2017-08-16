module Api
  class AbilityResource < JSONAPI::Resource
    has_one :hero
  end
end
