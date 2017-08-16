class ExtractorWorker
  include Sidekiq::Worker

  def perform(*args)

    fetch_heroes
    fetch_abilities

    # Untested because of the API status(429) Too Many Attempts.
    #fetch_abilities_other_way
    #fetch_abilities_other_way

  end


  def fetch_abilities
    stack = StackExchange.new('ability',1).abilities

    if stack.code == 200
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
  end

  def fetch_heroes
    stack = StackExchange.new('hero',1).heroes

    if stack.code == 200
      # Counting total
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

  def fetch_abilities_other_way
    stack = StackExchange.new('ability',1).abilities

    if stack.code == 200
      next_page = nil
      counter = 1

      # Amount of pages
      loop do
        abilities_response = StackExchange.new('overwatch',counter).abilities

        if abilities_response.code == 200
          next_page = abilities_response['next']
          abilities_collection = abilities_response['data']
          abilities_collection.each do |ability|
            exist = Ability.where(id: ability['id']).first.present?
            if !exist
              Ability.create( name: ability['name'], description: ability['description'], is_ultimate: ability['is_ultimate'], hero_id: ability['hero']['id'])
            end
          end
        else
          break
        end

        break if next_page.nil?
      end
    end
  end

  def fetch_heroes_other_way
    stack = StackExchange.new('hero',1).heroes

    if stack.code == 200
      next_page = nil
      counter = 1

      # Amount of pages
      loop do
        heroes_response = StackExchange.new('overwatch',counter).heroes

        if heroes_response.code == 200
          next_page = heroes_response['next']
          heroes_collection = heroes_response['data']
          heroes_collection.each do |hero|
            exist = Hero.where(id: hero['id']).first.present?
            if !exist
              Hero.create( name: hero['name'], real_name: hero['real_name'], health: hero['health'], armour: hero['armour'], shield: hero['shield'])
            end
          end
        else
          break
        end

        break if next_page.nil?
      end
    end
  end


end
