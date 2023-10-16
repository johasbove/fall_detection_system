class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.string :postal_code, limit: 15
      t.references :patient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
