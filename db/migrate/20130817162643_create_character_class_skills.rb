class CreateCharacterClassSkills < ActiveRecord::Migration
  def change
    create_table :character_class_skills do |t|
      t.integer :character_class_id
      t.integer :skill_id
      t.integer :from_level
      t.boolean :automatic
    end
  end
end
