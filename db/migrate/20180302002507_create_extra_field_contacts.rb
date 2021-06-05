class CreateExtraFieldContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :extra_field_contacts do |t|
      t.references :extra_field, foreign_key: true
      t.references :person, foreign_key: true
      t.string :value
      t.integer :kind
      t.integer :status

      t.timestamps
    end
  end
end
