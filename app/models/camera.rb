class Camera < ApplicationRecord
  validates :make, presence: true
  validates :model, presence: true

  has_many :boards

  def self.ransackable_attributes(auth_object = nil)
    ["id", "make", "model", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["boards"]
  end
end