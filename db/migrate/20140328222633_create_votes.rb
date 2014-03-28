class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :score
      t.room :references
      t.user :references

      t.timestamps
    end
  end
end
