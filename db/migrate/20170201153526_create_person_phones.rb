class CreatePersonPhones < ActiveRecord::Migration[6.1]
  def change
    create_table :person_phones do |t|
      t.references :person, foreign_key: true
      t.string :phone
      t.string :kind

      t.timestamps
    end
  end
end
