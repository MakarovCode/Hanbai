class ChangeMomentToBeRemember < ActiveRecord::Migration[6.1]
	def change
		remove_column :setups, :moment_to_be_remember
		add_column :setups, :moment_to_be_remember, :integer
	end
end
