class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates_presence_of :profile_img_url, :username

  has_many :tweets
  has_many :likes

  has_and_belongs_to_many   :friends,
                            class_name: 'User',
                            join_table: 'friends',
                            foreign_key: 'user_id',
                            association_foreign_key: 'friend_id'

  before_destroy do
    self.friends.destroy_all
    self.likes.destroy_all
    self.tweets.destroy_all
  end

  protected

  def serializable_hash(options = nil)
    super(options).merge(profile_img_url: profile_img_url, username: username)
  end
end
