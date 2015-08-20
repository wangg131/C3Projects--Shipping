class Package < ActiveRecord::Base
  validates :weight, presence: true
  validates :dimensions, presence: true

end
