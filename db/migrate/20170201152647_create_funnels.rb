class CreateFunnels < ActiveRecord::Migration[6.1]
	def change
		create_table :funnels do |t|
			t.string :name
			t.string :color
			t.string :image
			t.references :user, foreign_key: true
			t.integer :status

			t.timestamps
		end
	end
end
