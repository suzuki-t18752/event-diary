class Article < ApplicationRecord
  mount_uploader :image, ImageUploader

  has_rich_text :content
  belongs_to :user, optional: true
  has_many :comments
  has_many :comments, dependent: :destroy
  has_many :favorites
  has_many :favorites, dependent: :destroy
  
  
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  
  acts_as_taggable_on :labels
  acts_as_taggable
  
  def self.search(search)
    if search
      Article.where(['name LIKE ? OR created_at LIKE ?', "%#{search}%", "%#{search}%"])
    else
      Article.all #全て表示。
    end
  end
end
