class MainController < ApplicationController
  before_action :verify_authenticity_token, :except => [:index, :like_tweet]
  def index
    if user_signed_in?
      @friends_tweets = Tweet.tweets_for_me(current_user.friends.pluck(:friend_id)).order(created_at: 'desc').page(params[:page])
      @tweets = Tweet.order(created_at: 'desc').page(params[:page])
    else
      @tweets = Tweet.order(created_at: 'desc').page(params[:page])
    end
    @user_likes = Like.where(user_id: current_user.id).pluck(:tweet_id) rescue []
    @user_friend = Friend.where(user_id: current_user.id).pluck(:friend_id) rescue []
  end

  def show
    @tweet = Tweet.find(params[:tweet])
    @user_likes = Like.where(user_id: current_user.id).pluck(:tweet_id) rescue []
  end

  def all_tweets
    @tweets = Tweet.order(created_at: 'desc').page(params[:page])
    @user_likes = Like.where(user_id: current_user.id).pluck(:tweet_id) rescue []
  end

  def create_tweet
    logger.info(@user_likes)
    @tweet = Tweet.new
    @tweet.content = params[:content]
    @tweet.user = current_user
    if @tweet.save
      flash[:notice] = 'Tweet sent!'
      redirect_to :root
    else
      @tweets = Tweet.order(created_at: 'desc').page(params[:page])
      flash[:alert] = 'Content is mandatory'
      render :index
    end
  end

  def like_tweet
    @tweet = Tweet.find(params[:tweet])
    @like = Like.new
    @like.tweet = @tweet
    @like.user = current_user
    @like.save
    if @like.save
      flash[:notice] = "Tweet liked!"
      if user_signed_in?
        @tweets = Tweet.tweets_for_me(current_user.friends.pluck(:friend_id)).order(created_at: 'desc').page(params[:page])
        @tweets = Tweet.order(created_at: 'desc').page(params[:page])
      else
        @tweets = Tweet.order(created_at: 'desc').page(params[:page])
      end
      @user_likes = Like.where(user_id: current_user.id).pluck(:tweet_id) rescue []
      @user_friend = Friend.where(user_id: current_user.id).pluck(:friend_id) rescue []
      respond_to do |format|
        format.js { render json: render_to_string('_tweets'), status: :created }
        # render json: { html: render_to_string(partial: 'random') }
      end
    else
    end
    # redirect_to :root
  end

  def unlike_tweet
    @like = Like.where(user_id: current_user.id).where(tweet_id: params[:tweet]).first
    @like.destroy
    flash[:notice] = "Tweet unliked!"
    redirect_to :root
  end

  def retweet
    @original = Tweet.find(params[:tweet])
    @tweet = Tweet.new
    @tweet.content = @original.content
    @tweet.user = current_user
    @tweet.tweet_id = @original.id
    @tweet.save
    @original.retweets = @original.retweets + 1
    @original.save
    flash[:notice] = 'Tweet retweeted!'
    redirect_to :root
  end

  def search
    @tweets = Tweet.where('content like :q', q: "%#{params[:q]}%").page(params[:page])
    @user_likes = Like.where(user_id: current_user.id).pluck(:tweet_id) rescue []
  end

  def mytweets
    @tweets = Tweet.where(user_id: current_user.id).page(params[:page])
    @user_likes = Like.where(user_id: current_user.id).pluck(:tweet_id) rescue []
  end

  def myprofile
    @tweets = Tweet.where(user_id: current_user.id).page(params[:page])
    @following = Friend.where(user_id: current_user.id).page(params[:page])
    @follower = Friend.where(friend_id: current_user.id).page(params[:page])
  end

  def follow
    @follow = Friend.new
    @follow.user = current_user
    @follow.friend = User.find(params[:friend])
    if @follow.save
      flash[:notice] = "Follow Successfully..."
      redirect_back fallback_location: root_path
    end
  end

  def unfollow
    @follow = Friend.where(user_id: current_user.id).where(friend_id: params[:friend]).first
    
    if @follow.destroy
      flash[:notice] = "Unfollow Successfully..."
      redirect_back fallback_location: root_path
    end
  end

  def listfollower
    @friends = Friend.where(friend_id: current_user.id).page(params[:page])
  end

  def listfollowing
    @friends = Friend.where(user_id: current_user.id).page(params[:page])
  end

  def userprofile
    @user = User.find(params[:user])
    @tweets = Tweet.where(user_id: @user.id).page(params[:page])
    @following = Friend.where(user_id: @user.id).page(params[:page])
    @follower = Friend.where(friend_id: @user.id).page(params[:page])
  end

  def usertweets
    @user = User.find(params[:user])
    @tweets = Tweet.where(user_id: @user.id).page(params[:page])
    @user_likes = Like.where(user_id: @user.id).pluck(:tweet_id) rescue []
  end
end
