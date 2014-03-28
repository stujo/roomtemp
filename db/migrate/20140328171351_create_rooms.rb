class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.references :user, index: true

      t.timestamps
    end
  end
end
