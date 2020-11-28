ActiveAdmin.register User do

  permit_params :email, :profile_img_url, :username, :password, :password_confirmation

  form do |f|
    f.inputs do
      f.input :username
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :profile_img_url
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :email
    column ('Tweets') { |u| u.tweets.count }
    column ('Likes') { |u| u.likes.count }
    column ('Retweets') { |u| u.tweets.sum(:retweets) }
    column :profile_img_url
    actions
  end
  
end
