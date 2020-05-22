class Post < ApplicationRecord
  belongs_to :user
   validates :content, presence: true, length: { maximum: 255 }
   validates :title, presence: true, length: { maximum: 30 }
   validates :image_name, presence: true
    mount_uploader :image_name, PostimageUploader
   has_many :comments, dependent: :destroy
end


