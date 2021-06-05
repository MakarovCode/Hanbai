class ExtraFieldDeal < ApplicationRecord
  belongs_to :extra_field
  belongs_to :deal

  def self.actives
    where status: [0,nil]
  end

  def self.inactives
    where status: 1
  end
end
