object @notes

attributes :id, :text

child :person do 
	attributes :id, :name

	child :company do 
		attributes :id, :name
	end

end

child :company do 
	attributes :id, :name
end