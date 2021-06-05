class CreateUserFunnels < ActiveRecord::Migration[6.1]
  def change
    create_table :user_funnels do |t|
      t.references :user, foreign_key: true
      t.references :funnel, foreign_key: true
      t.string :permission

      t.timestamps
    end
  end
end
