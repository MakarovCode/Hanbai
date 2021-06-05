class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :tags
      t.string :image
      t.string :video
      t.string :author
      t.date :date

      t.timestamps
    end
  end
end
