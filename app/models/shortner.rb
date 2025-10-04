class Shortner < ApplicationRecord
  has_many :items
  belongs_to :user, optional: true
  
  validates :url, presence: true, format: { 
    with: URI::regexp(%w[http https]), 
    message: "must be a valid URL" 
  }
  validates :url, uniqueness: { 
    message: "has already been shortened" 
  }
end
