class Device < ApplicationRecord
  belongs_to :health_center
  belongs_to :patient

  has_many :alerts
end
