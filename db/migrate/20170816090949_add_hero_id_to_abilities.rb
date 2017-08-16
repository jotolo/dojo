class AddHeroIdToAbilities < ActiveRecord::Migration[5.0]
  def change
    add_column :abilities, :hero_id, :integer
  end
end
