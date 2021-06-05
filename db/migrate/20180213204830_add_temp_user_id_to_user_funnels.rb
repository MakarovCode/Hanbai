class AddTempUserIdToUserFunnels < ActiveRecord::Migration[6.1]
  def change
    add_column :user_funnels, :tmp_user_id, :integer
  end
end
