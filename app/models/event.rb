class Event < ApplicationRecord
  belongs_to :creator, :class_name => "User"
  has_many :invitations, :foreign_key => :attended_event_id
  has_many :attendees, :through => :invitations
  validates :creator_id, presence: true
  validates :description, presence: true
  validates :title, presence: true, length: { maximum: 150 }
  validates :date, presence: true
  validates :location, presence: true

  scope :upcoming, -> { where("Date >= ?", Date.today).order('Date ASC') }
  scope :past, -> { where("Date < ?", Date.today).order('Date DESC') }
end
