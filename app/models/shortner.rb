class Shortner < ApplicationRecord
  has_many :items
  belongs_to :user, optional: true

  validates :url, presence: true, uniqueness: { message: "has already been shortened" }
end
