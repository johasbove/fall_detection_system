class Patient < ApplicationRecord
  belongs_to :health_center

  has_one :address
  has_one :divice
end
