class CreateCharacterSkills < ActiveRecord::Migration
  def change
    create_table :characters_skills do |t|
      t.integer :character_id
      t.integer :skill_id
    end
  end
end
