class Camera < ApplicationRecord
  validates :make, presence: true
  validates :model, presence: true
end