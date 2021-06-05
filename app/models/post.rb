class Post < ApplicationRecord
	mount_uploader :image, AttachmentUploader
	
	validates :title, :content, :date, :image, :tags, :author, presence: true
end
