class Meetup < ActiveRecord::Base
  validates :title, :description, presence: true
end
