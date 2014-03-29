class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :score
      t.references :room, index: true
      t.references :user, index: true
      t.timestamps
    end
  end
end
