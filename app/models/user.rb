class User < ApplicationRecord
  mount_uploader :image, ProfileUploader
  
  validates :name, presence: true, length: { maximum: 25 }
  validates :introduction, presence: true, length: { maximum: 200 }          
  has_secure_password
  
  has_many :articles
  has_many :comments
  
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :relationships, dependent: :destroy
  has_many :reverses_of_relationship, dependent: :destroy
  
  
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  has_many :favorites
  has_many :favorites, dependent: :destroy
  
  
  def self.search(search) #self.でクラスメソッドとしている
    if search # Controllerから渡されたパラメータが!= nilの場合は、titleカラムを部分一致検索
      User.where(['name LIKE ? OR introduction LIKE ?', "%#{search}%", "%#{search}%"])
    else
      User.all #全て表示。
    end
  end
end
