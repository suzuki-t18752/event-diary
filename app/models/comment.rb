class Comment < ApplicationRecord
  validates :content, presence: true, length: { maximum: 50 }
  
  belongs_to :article
  belongs_to :user
end
