class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

         #has_many :events, dependent: :destroy
         #has_many :comments, dependent: :destroy

         scope :all_except, ->(user) { where.not(id: user) }
         acts_as_messageable

    def name
      email.split('@')[0]
    end

    def mailboxer_email(object)
      email
    end
end
