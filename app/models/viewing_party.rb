class ViewingParty < ApplicationRecord
  has_many :user_parties
  has_many :users, through: :user_parties

  validate :duration_cannot_be_shorter_than_movie

  validates :start_time, presence: true
  validates :date, presence: true
  validates :duration, presence: true
  validates :movie_id, presence: true
  validates :movie_duration, presence: true, numericality: true

  def find_host
    users.where("user_parties.host = true").first
  end

  def duration_cannot_be_shorter_than_movie
    if duration.present? && duration < movie_duration
      errors.add(:duration, "cannot be shorter than movie runtime")
    end
  end
end
