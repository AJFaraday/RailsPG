class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|

      t.string :name
      t.string :label
      t.integer :skill_cost
      t.integer :range
      t.boolean :offensive

      t.timestamps
    end
  end
end
