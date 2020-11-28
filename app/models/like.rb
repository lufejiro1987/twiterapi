class Like < ApplicationRecord
  belongs_to :tweet, dependent: :destroy
  belongs_to :user
  validates_uniqueness_of :tweet_id
end
