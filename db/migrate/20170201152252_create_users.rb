class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :uuid
      t.string :image
      t.string :how
      t.integer :status

      t.timestamps
    end
  end
end
