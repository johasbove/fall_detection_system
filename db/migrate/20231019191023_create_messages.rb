class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :alert, null: false, foreign_key: true
      t.integer :status
      t.references :caregiver, null: false, foreign_key: true

      t.timestamps
    end
  end
end
