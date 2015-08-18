class Destination < ActiveRecord::Base
  validates :name, presence: true
  validates :country, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
end
