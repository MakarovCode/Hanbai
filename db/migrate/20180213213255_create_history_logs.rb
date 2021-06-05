class CreateHistoryLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :history_logs do |t|
      t.references :user, foreign_key: true
      t.references :funnel, foreign_key: true
      t.references :stage, foreign_key: true
      t.references :deal, foreign_key: true
      t.references :activity, foreign_key: true
      t.text :action_text

      t.timestamps
    end
  end
end
