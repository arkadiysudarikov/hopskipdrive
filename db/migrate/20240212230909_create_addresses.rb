class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses, id: :uuid do |t|
      t.string :address, index: {unique: true}

      t.timestamps
    end
  end
end
