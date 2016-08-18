class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  before_save :ensure_authentication_token!
  scope :all_except, ->(user) { where.not(id: user) }
  acts_as_messageable
  attr_accessor :first_name, :last_name
  validates :email, presence: true

  def name
    email.split('@')[0]
  end

  def mailboxer_email(object)
    email
  end

  def ensure_authentication_token!
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      token = generate_secure_token_string
      break token unless User.where(authentication_token: token).first
    end
  end

  def generate_secure_token_string
    SecureRandom.urlsafe_base64(25).tr('lIO0', 'sxyz')
  end

  def authenticate_token
    authenticate_or_request_with_http_token do |token, options|
      User.find_by(uthentication_token: token)
    end
  end
end
