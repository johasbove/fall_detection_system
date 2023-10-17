class CreateAlerts < ActiveRecord::Migration[7.0]
  def change
    create_table :alerts do |t|
      t.datetime :received_at
      t.string :received_value
      t.integer :alert_type
      t.float :latitude
      t.float :longitud
      t.references :device, null: false, foreign_key: true

      t.timestamps
    end
  end
end
