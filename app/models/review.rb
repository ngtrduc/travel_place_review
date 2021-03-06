class Review < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: -> (controller, model){controller && controller.current_user},
    recipient: :book

  belongs_to :user
  belongs_to :book
  validates :book_id, uniqueness: {scope: :user_id}
  has_many :comments, dependent: :destroy
  has_many :review_votes, dependent: :destroy
  validates_inclusion_of :rating, in: 0..5

  validates :content, presence: true

  scope :created_between, ->start_date, end_date{where("DATE(created_at) >=
    ? AND DATE(created_at) <= ?", start_date, end_date)}
  scope :order_reviews, ->{order created_at: :DESC}
  scope :last_reviews, ->{order(created_at: :desc).limit 5}
  scope :top_review, -> do
    order "vote_count DESC"
  end
  after_create :update_book_rate_avg

  def update_votes
    update_attributes vote_count: review_votes.size
  end

  private
  def update_book_rate_avg
    book.update_rate_avg
  end
end
