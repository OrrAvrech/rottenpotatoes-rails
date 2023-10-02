require 'byebug'

class Movie < ActiveRecord::Base

  def self.all_ratings
    return ['G','PG','PG-13','R']
  end

  def self.with_ratings(ratings_list)
    # handle nil or empty ratings_list
    return Movie.all if ratings_list.nil? || ratings_list.empty?

    Movie.where(rating: ratings_list.keys.map(&:upcase))
  end

end
