class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :event
  after_create_commit { create_event }
 
  private
 
  def create_event
    self.user.events.create message: "A new comment has been created"
  end
end
