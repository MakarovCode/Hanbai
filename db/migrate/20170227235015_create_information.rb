class CreateInformation < ActiveRecord::Migration[6.1]
  def change
    create_table :information do |t|
      t.string :title
      t.string :main_image
      t.string :main_title
      t.string :main_text
      t.string :main_sub_text
      t.string :main_color
      t.string :services_title
      t.string :services_text
      t.string :contact_info
      t.string :contact_text
      t.string :contact_title
      t.string :login_title
      t.string :login_text
      t.string :login_image
      t.string :register_title
      t.string :register_text
      t.string :register_image
      t.string :logo
      t.string :rights
      t.text :about_us

      t.timestamps
    end
  end
end
