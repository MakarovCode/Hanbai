class CreateStages < ActiveRecord::Migration[6.1]
	def change
		create_table :stages do |t|
			t.string :name
			t.boolean :is_standing
			t.integer :priority
			t.references :funnel, foreign_key: true
			t.integer :status

			t.timestamps
		end
	end
end
