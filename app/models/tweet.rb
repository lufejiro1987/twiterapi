class Tweet < ApplicationRecord
  belongs_to :user
  belongs_to :original, class_name: 'Tweet', foreign_key: 'tweet_id', optional: true
  has_many :likes
  paginates_per 50

  validates_presence_of :content

  scope :tweets_for_me, ->(friends_ids) { where(user_id: friends_ids) }
end
