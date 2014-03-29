class CurrentVote < ActiveRecord::Base
  belongs_to :room, touch: true
  belongs_to :user
  validates_uniqueness_of :user, :scope => [:room]
end
