class CreateEffects < ActiveRecord::Migration
  def change
    create_table :effects do |t|
      t.integer :attribute_effect_id
      t.integer :repeat_effect_id
      t.integer :amount
      t.integer :character_id
      t.integer :turns_remaining
    end
  end
end
