class User < ApplicationRecord
  # Associations
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :clock_ins

  # Follow a user
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollow a user
  def unfollow(other_user)
    follower = active_relationships.find_by(followed_id: other_user.id)
    follower.destroy if follower
  end
end
