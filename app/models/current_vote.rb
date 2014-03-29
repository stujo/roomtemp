class CurrentVote < ActiveRecord::Base
  belongs_to :room
  belongs_to :user
  validates_uniqueness_of :user, :scope => [:room]
end
