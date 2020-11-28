class AddRetweetsToTweet < ActiveRecord::Migration[6.0]
  def change
    add_column :tweets, :retweets, :integer
  end
end
