class Room < ActiveRecord::Base
  belongs_to :user
  delegate :name, to: :user, prefix: true, allow_nil: true
  validates :name, uniqueness: { case_sensitive: true }
  has_many :current_votes

  STATUS_CLOSED = 0
  STATUS_OPEN = 1

  scope :active,               -> { where(status: STATUS_OPEN) }
  scope :belongingTo,          -> (user) { where(user: user) }

  self.per_page = 10

  def active?
    status == STATUS_OPEN
  end

  def temperature
    current_votes.average(:score)
  end

  def cached_temperature
    Rails.cache.fetch([self, "temperature"]) { temperature }
  end
end
