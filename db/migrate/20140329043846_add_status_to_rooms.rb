class AddStatusToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :status, :integer
  end
end
