class CreateSkillEffects < ActiveRecord::Migration
  def change
    create_table :skill_effects do |t|

      t.string :name
      t.string :target_trait
      t.integer :magnitude
      t.string :related_trait
      t.boolean :defendable
      t.boolean :evadeable
      t.integer :skill_id
  
      t.timestamps
    end
  end
end
