class CreateRides < ActiveRecord::Migration[7.1]
  def change
    create_table :rides, id: :uuid do |t|
      t.references :start_address, null: false, foreign_key: { to_table: :addresses }, type: :uuid
      t.references :destination_address, null: false, foreign_key: { to_table: :addresses }, type: :uuid

      t.timestamps
    end
  end
end
