class CreateExtraFields < ActiveRecord::Migration[6.1]
  def change
    create_table :extra_fields do |t|
      t.string :name
      t.integer :kind
      t.boolean :required
      t.integer :object_type
      t.references :funnel, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
