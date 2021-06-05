class CreateAttachments < ActiveRecord::Migration[6.1]
  def change
    create_table :attachments do |t|
      t.references :deal, foreign_key: true
      t.references :person, foreign_key: true
      t.string :source

      t.timestamps
    end
  end
end
