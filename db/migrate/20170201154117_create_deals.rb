class CreateDeals < ActiveRecord::Migration[6.1]
	def change
		create_table :deals do |t|
			t.string :title
			t.references :creator_user, foreign_key: { to_table: :users }
			t.references :user, foreign_key: true
			t.float :value
			t.float :tax
			t.float :total
			t.float :commission
			t.references :stage, foreign_key: true
			t.references :person, foreign_key: true
			t.datetime :stage_change_time
			t.datetime :won_time
			t.datetime :lost_time
			t.datetime :close_time
			t.text :lost_reason
			t.integer :activities_count, default: 0
			t.integer :done_activities_count, default: 0
			t.integer :undone_activities_count, default: 0
			t.integer :status
			t.string :currency
			t.integer :priority

			t.timestamps
		end
	end
end
