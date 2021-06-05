class UserFunnel < ApplicationRecord
  belongs_to :user
  belongs_to :funnel
end
