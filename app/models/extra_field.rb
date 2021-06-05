class ExtraField < ApplicationRecord

  belongs_to :user
  belongs_to :funnel

  has_many :extra_field_contacts
  has_many :people, through: :extra_field_contacts

  has_many :extra_field_deals
  has_many :deals, through: :extra_field_deals

  validates :name, :kind, :object_type, presence: true


  TEXT = 1
  INTEGER = 2
  DECIMAL = 3
  BOOLEAN = 4
  DATE = 5
  TIME = 6
  TEXTAREA = 7

  def self.actives
    where status: [0,nil]
  end

  def self.inactives
    where status: 1
  end

  def get_kind_name
    if self.kind == TEXT
      "text"
    elsif self.kind == INTEGER
      "number"
    elsif self.kind == DECIMAL
      "number"
    elsif self.kind == BOOLEAN
      "checkbox"
    elsif self.kind == DATE
      "date"
    elsif self.kind == TIME
      "time"
    elsif self.kind == TEXTAREA
      "textarea"
    else
      "text"
    end
  end
end
