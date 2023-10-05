class Movie < ActiveRecord::Base

  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']
  end

  def self.with_ratings(ratings)
    where("lower(rating) IN (?)", ratings.map(&:downcase))
  end
  
end