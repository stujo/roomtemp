class CreateCurrentVotes < ActiveRecord::Migration
  def change
    create_table :current_votes do |t|
      t.integer :score
      t.references :room, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
