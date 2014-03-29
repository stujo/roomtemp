class Room < ActiveRecord::Base
  belongs_to :user
  delegate :name, to: :user, prefix: true, allow_nil: true
  validates :name, uniqueness: { case_sensitive: true }
  has_many :current_votes

  self.per_page = 10

  def temperature
    current_votes.average(:score)
  end

  def cached_temperature
    Rails.cache.fetch([self, "temperature"]) { temperature }
  end
end
