class CreatePeople < ActiveRecord::Migration[6.1]
	def change
		create_table :people do |t|
			t.references :company, foreign_key: true
			t.string :name
			t.text :notes
			t.references :user, foreign_key: true
			t.integer :open_deals_count, default: 0
			t.integer :won_deals_count, default: 0
			t.integer :closed_deal_count, default: 0
			t.integer :activities_count, default: 0
			t.integer :done_activities_count, default: 0
			t.integer :undone_activities_count, default: 0
			t.integer :status

			t.timestamps
		end
	end
end
