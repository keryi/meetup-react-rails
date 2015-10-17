class Meetup < ActiveRecord::Base
  validates :title, :description, presence: true

  serialize :guests, JSON

  def guests=(guests)
    super(guests.select(&:present?).map(&:strip))
  end
end
