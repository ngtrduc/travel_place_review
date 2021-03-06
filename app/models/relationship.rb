class Relationship < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: :follower, recipient: :followed

  belongs_to :follower, class_name: User.name
  belongs_to :followed, class_name: User.name

  validates :follower, presence: true
  validates :followed, presence: true
end
