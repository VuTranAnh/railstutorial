class Micropost < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :content, length: {maximum: 140}
  validates :content, presence: true

  scope :latest_order, -> {order created_at: :desc}
  scope :followed_posts, -> following_ids, user_id do
    where "user_id IN (#{following_ids}) OR user_id = user_id"
  end

  mount_uploader :picture, PictureUploader

  private
  def piture_size
    if picture.size > Settings.picture_max_sizes.megabytes
      errors.add :picture, t("maximum_size_message")
    end
  end
end
