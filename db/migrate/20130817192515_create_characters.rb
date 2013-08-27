class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|

      t.string :name, :null => false
      t.integer :character_class_id, :null => false
      t.boolean :player, :default => false

      t.integer :game_id # specific game in play
      t.integer :adventure_id # adventure, a template character
      t.integer :level_id
      t.integer :row
      t.integer :column

      t.integer :exp, :default => 0
      t.integer :level, :default => 1
      t.integer :level_up_target, :default => 10

      bars = ['health','skill']
      bars.each do |bar|
        t.integer bar
        t.integer "max_#{bar}"
      end

      traits = ['attack','defence','melee','ranged','evade','luck','speed']
      traits.each do |trait|
        t.integer trait, :null => false
      end
    end
  end
end
