class AddAvatarLocationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar_location, :string
  end
end
