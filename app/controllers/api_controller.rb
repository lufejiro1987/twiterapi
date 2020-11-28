class ApiController < ApplicationController
    skip_before_action :verify_authenticity_token  

    def news
        tweets = Tweet.all.order(created_at: :desc).limit(50)
        
        if tweets.present?
            all_tweets = []
            tweets.each do |tweet|
                all_tweets.push({
                    id: tweet.id,
                    content: tweet.content,
                    user_id: tweet.user_id,
                    like_count: tweet.likes.try(:count).to_i,
                    retweets_count: tweet.retweets,
                    retwitted_from: tweet.tweet_id
                })
            end
            render json: all_tweets
        else
            render json: {message: "no tweets found"}
        end
    end

    def tweetsbydate
        if params[:date1].present? && params[:date2].present?
            tweets = Tweet.where("created_at BETWEEN :first_date AND :second_date", first_date: params[:date1].to_datetime.beginning_of_day, second_date: params[:date2].to_datetime.end_of_day)
            if tweets.present?
                all_tweets = []
                tweets.each do |tweet|
                    all_tweets.push({
                        id: tweet.id,
                        content: tweet.content,
                        user_id: tweet.user_id,
                        like_count: tweet.likes.try(:count).to_i,
                        retweets_count: tweet.retweets,
                        retwitted_from: tweet.tweet_id
                    })
                end
                render json: all_tweets
            else
                render json: {message: "no tweets found"}
            end
        else
            render json: {message: "Please enter dates."}
        end
    end

    def new_tweet
        if params[:email].present? && params[:password].present?
            user = User.find_by_email(params[:email])
            if user.try(:valid_password?, params[:password])
                if params[:content].present?
                    @tweet = Tweet.new
                    @tweet.content = params[:content]
                    @tweet.user = user
                    if @tweet.save
                        render json: {message: "Tweet created succefully!"}
                    else
                        render json: {message: @tweets.errors}
                    end
                else
                    render json: {message: "missing content!"}
                end
            else
                render json: {message: "email or password incorrect!"}
            end
        else
            render json: {message: "missing email or password!"}
        end
    end
end
