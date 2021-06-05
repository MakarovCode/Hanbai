class Contact < ApplicationRecord
  belongs_to :user

  validates :name, :email, :subject, :message, presence: true
end
