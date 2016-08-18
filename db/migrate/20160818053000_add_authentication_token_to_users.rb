class AddAuthenticationTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :authentication_token, :text, limit: 30
    add_index :users, :authentication_token, unique: true
  end
end
