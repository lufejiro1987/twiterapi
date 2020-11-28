Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  root 'main#index'
  post 'create', to: 'main#create_tweet', as: 'create_tweet'
  post 'like/:tweet', to: 'main#like_tweet', as: 'like_tweet'
  post 'follow/:friend', to: 'main#follow', as: 'follow_user'
  post 'unfollow/:friend', to: 'main#unfollow', as: 'unfollow_user'
  post 'unlike/:tweet', to: 'main#unlike_tweet', as: 'unlike_tweet'
  post 'retweet/:tweet', to: 'main#retweet', as: 'retweet'
  get 'show/:tweet', to: 'main#show', as: 'show'
  get 'user/:user', to: 'main#userprofile', as: 'userprofile'
  get 'tweets/:user', to: 'main#usertweets', as: 'usertweets'
  get 'mytweets', to: 'main#mytweets'
  get 'myprofile', to: 'main#myprofile'
  get 'followers', to: 'main#listfollower'
  get 'following', to: 'main#listfollowing'
  get 'search', to: 'main#search', as: 'search'

  post "api/news"
  post "api/:date1/:date2", to: "api#tweetsbydate"
  post "api/new_tweet"
end