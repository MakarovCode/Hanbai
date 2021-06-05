class AddFieldsToInformation < ActiveRecord::Migration[6.1]
  def change
    add_column :information, :service1_title, :string
    add_column :information, :service1_icon, :string
    add_column :information, :service1_text, :string
    add_column :information, :service2_title, :string
    add_column :information, :service2_icon, :string
    add_column :information, :service2_text, :string
    add_column :information, :service3_title, :string
    add_column :information, :service3_icon, :string
    add_column :information, :service3_text, :string
    add_column :information, :video, :string
    add_column :information, :video_title, :string
    add_column :information, :video_text, :string
    add_column :information, :call_to_action_blog_title, :string
    add_column :information, :call_to_action_blog_text, :string
    add_column :information, :logo_inverse, :string
    add_column :information, :call_to_action_blog_image, :string
  end
end
