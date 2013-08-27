class CreateSkillEffects < ActiveRecord::Migration
  def change
    create_table :skill_effects do |t|

      t.string  :name
      t.string  :target_trait
      t.float   :magnitude
      t.float   :magnitude_mod
      t.string  :related_trait
      t.boolean :defendable
      t.boolean :evadeable
      t.boolean :repeat_defendable
      t.boolean :repeat_evadeable
      t.integer :spawn_character_class_id

      t.integer :skill_id
      t.string  :type

      t.integer :length
      t.float   :length_mod
    end
  end
end
