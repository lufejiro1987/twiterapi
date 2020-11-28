class ModifyDefaultToRetweetsInTweets < ActiveRecord::Migration[6.0]
  def change
    change_column_default :tweets, :retweets, 0
  end
end
