class CreateCaregivers < ActiveRecord::Migration[7.0]
  def change
    create_table :caregivers do |t|
      t.string :phone
      t.string :reference_code, null: false
      t.references :health_center, null: false, foreign_key: true

      t.timestamps
    end
  end
end
