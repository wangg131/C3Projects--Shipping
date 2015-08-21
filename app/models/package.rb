class Package < ActiveRecord::Base
  validates :weight, presence: true
  validates :sizing, presence: true
  validates :order_id, presence: true
  validates :price, presence: true
  validates :service_type, presence: true
end
