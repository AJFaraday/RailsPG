class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :adventure_id
      t.string :name
      t.string :ip_address
      t.boolean :current

      t.timestamps
    end
  end
end
