object @companies

attributes :id

node :label do |company|
	company.name
end