class CreateCharacterClasses < ActiveRecord::Migration
  def change
    create_table :character_classes do |t|
      t.string :name, :null => false
      t.string :description
      t.boolean :playable
      traits = ['health','skill','attack','defence','melee','ranged','evade','luck','speed']
      traits.each do |trait|
        t.integer "init_#{trait}", :null => false 
        t.integer "#{trait}_mod", :null => false
      end      
    end
  end
end
