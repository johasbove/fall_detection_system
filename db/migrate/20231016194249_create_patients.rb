class CreatePatients < ActiveRecord::Migration[7.0]
  def change
    create_table :patients do |t|
      t.string :first_name
      t.string :last_name
      t.text :additional_information
      t.references :health_center, null: false, foreign_key: true

      t.timestamps
    end
  end
end
