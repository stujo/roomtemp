class Room < ActiveRecord::Base
  belongs_to :user
  delegate :name, to: :user, prefix: true, allow_nil: true
  validates :name, uniqueness: { case_sensitive: true }

  self.per_page = 10

end
