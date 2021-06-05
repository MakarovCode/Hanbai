class CreatePersonAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :person_addresses do |t|
      t.references :person, foreign_key: true
      t.string :address
      t.string :kind

      t.timestamps
    end
  end
end
