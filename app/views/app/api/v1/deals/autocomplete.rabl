object @deals

attributes :id

node :label do |deal|
	deal.title
end