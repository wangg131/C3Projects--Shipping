class Package < ActiveRecord::Base
  validates :weight, presence: true
  validates :height, presence: true
  validates :width, presence: true 
end
