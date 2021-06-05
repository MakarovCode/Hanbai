class CreatePersonEmails < ActiveRecord::Migration[6.1]
  def change
    create_table :person_emails do |t|
      t.references :person, foreign_key: true
      t.string :email
      t.string :kind

      t.timestamps
    end
  end
end
