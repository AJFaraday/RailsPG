class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.integer :adventure_id
      t.string :name
      t.integer :rows
      t.integer :columns
      t.string :obstacle_positions
    end
  end
end
