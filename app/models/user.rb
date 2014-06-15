#
# User model
#
class User < ActiveRecord::Base

  has_many :articles
  devise   :database_authenticatable, :registerable,
           :rememberable, :trackable, :validatable

  validates :login_id, presence: true, uniqueness: true, length: { minimum:5, maximum: 30 }

  def email_required?
    false
  end
end
