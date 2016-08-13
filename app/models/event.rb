class Event < ApplicationRecord
  belongs_to :user
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  has_many :comments, dependent: :destroy
  after_create_commit { EventBroadcastJob.perform_later self }
end
