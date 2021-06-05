class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :subject
      t.text :message
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
