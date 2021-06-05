class Attachment < ApplicationRecord
	belongs_to :deal
	belongs_to :person

	mount_uploader :source, AttachmentUploader
	
	validates :source, presence: true
end
