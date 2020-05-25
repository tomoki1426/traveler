class User < ApplicationRecord
     before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  validates :content,  length: { maximum: 100 }
  mount_uploader :image_name, UserimageUploader
  has_secure_password
  
   has_many :comments, foreign_key: :user_id, dependent: :destroy

    
  has_many :posts, foreign_key: :user_id, dependent: :destroy
  has_many :relationships, foreign_key: :user_id, dependent: :destroy
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  has_many :favorites, foreign_key: :user_id, dependent: :destroy
  has_many :likes, through: :favorites, source: :post
  has_many :reverses_of_favorite, class_name: 'Favorite', foreign_key: 'post_id'
  has_many :liked, through: :reverses_of_favorite, source: :user
  
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
  
  def liking(like_post)
      self.favorites.find_or_create_by(post_id: like_post.id)
  end

  def unlike(like_post)
    favorite = self.favorites.find_by(post_id: like_post.id)
    favorite.destroy if favorite
  end

  def liking?(like_post)
    self.likes.include?(like_post)
  end

  def feed_posts
    Post.where(user_id: self.following_ids + [self.id])
  end
  
  def self.search(search)
    if search
      User.where('name LIKE(?)', "%#{search}%")
    else
      User.all
    end
  end
end



