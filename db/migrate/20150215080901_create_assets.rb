class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :asset
      t.integer :ticket_id

      t.timestamps null: false
    end
  end
end
