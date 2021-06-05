class Information < ApplicationRecord

  mount_uploader :main_image, AttachmentUploader
  mount_uploader :login_image, AttachmentUploader
  mount_uploader :register_image, AttachmentUploader
  mount_uploader :logo, AttachmentUploader
  mount_uploader :logo_inverse, AttachmentUploader
  mount_uploader :call_to_action_blog_image, AttachmentUploader

  # validates :title ,:main_image ,:main_title ,:main_text ,:main_sub_text ,:main_color ,:services_title ,:services_text ,:contact_info ,:contact_text ,:contact_title ,:login_title ,:login_text ,:login_image ,:register_title ,:register_text ,:register_image ,:logo ,:rights ,:about_us, presence: true


end
