class ExtractorWorker
  include Sidekiq::Worker

  def perform(*args)

    fetch_abilities

    fetch_heroes

  end


  def fetch_abilities
    stack = StackExchange.new('overwatch',1).abilities
    # Counting pages
    page_counter = stack['total']

    # Amount of pages
    page_counter.times do |i|
      abilities_response = StackExchange.new('overwatch',i + 1).abilities
      if abilities_response.code == 200
        abilities_collection = abilities_response['data']
        abilities_collection.each do |ability|
          exist = Ability.where(id: ability['id']).first.present?
          if !exist
            Ability.create( name: ability['name'], description: ability['description'], is_ultimate: ability['is_ultimate'], hero_id: ability['hero']['id'])
          end
        end
      end
    end
  end

  def fetch_heroes
    stack = StackExchange.new('heroes',1).heroes
    # Counting pages
    page_counter = stack['total']

    # Amount of pages
    page_counter.times do |i|
      heroes_response = StackExchange.new('overwatch',i + 1).heroes
      if heroes_response.code == 200
        heroes_collection = heroes_response['data']
        heroes_collection.each do |hero|
          exist = Hero.where(id: hero['id']).first.present?
          if !exist
            Hero.create( name: hero['name'], real_name: hero['real_name'], health: hero['health'], armour: hero['armour'], shield: hero['shield'])
          end
        end
      end
    end
  end
end
