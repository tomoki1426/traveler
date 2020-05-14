class Post < ApplicationRecord
  belongs_to :user
   validates :content, presence: true, length: { maximum: 255 }
   validates :title, presence: true, length: { maximum: 30 }
    mount_uploader :image_name, PostimageUploader
end
