class StackExchange
  include HTTParty
  base_uri 'overwatch-api.net'

  def initialize(service, page)
    @options = { query: { site: service, page: page } }
  end

  def heroes
    self.class.get('/api/v1/hero', @options)
  end

  def hero(hero_id)
    if hero_id.nil?
      nil
    else
      self.class.get("/api/v1/hero/#{hero_id}", @options)
    end
  end

  def abilities
    self.class.get('/api/v1/ability', @options)
  end

  def ability(ability_id)
    if ability_id.nil?
      nil
    else
      self.class.get("/api/v1/ability/#{ability_id}", @options)
    end
  end
end
