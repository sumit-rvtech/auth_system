class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

         has_many :events, dependent: :destroy
         has_many :comments, dependent: :destroy

         scope :all_except, ->(user) { where.not(id: user) }

    def send_message(rec, sub, mess)
    	@user = User.find(rec)
    	@event = @user.events.create(message: mess,subject: sub, sender_id: self.id, receiver_id: rec,read: false)
    end
end
