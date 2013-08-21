class CreateDoors < ActiveRecord::Migration
  def change
    create_table :doors do |t|

      t.integer :level_id
      t.integer :row
      t.integer :column
      t.integer :destination_level_id
      t.integer :destination_row
      t.integer :destination_column

    end
  end
end
