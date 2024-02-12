class CreateDrivers < ActiveRecord::Migration[7.1]
  def change
    create_table :drivers, id: :uuid do |t|
      t.references :home_address, null: false, foreign_key: { to_table: :addresses }, type: :uuid

      t.timestamps
    end
  end
end
