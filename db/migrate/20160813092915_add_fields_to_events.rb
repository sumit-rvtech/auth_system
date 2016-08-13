class AddFieldsToEvents < ActiveRecord::Migration[5.0]
  def change
  	add_column :events, :sender_id, :integer
  	add_column :events, :receiver_id, :integer
  	add_column :events, :subject, :string
  	add_column :events, :read, :boolean
  	add_column :comments, :event_id, :integer
  end
end
