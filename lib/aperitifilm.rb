require 'nokogiri'
require 'open-uri'

require_relative './aperitifilm/version.rb'
require_relative './aperitifilm/movie.rb'
require_relative './aperitifilm/ranking.rb'
require_relative './aperitifilm/ranking_position.rb'
require_relative './aperitifilm/blank_position.rb'

module Aperitifilm
  def self.run(usernames, number_of_movies = 20)
    usernames = Array(usernames)

    movie_listings = usernames.map do |username|
      puts "Fetching movies for #{username}"
      fetch_movies(username)
    end

    ranking = create_ranking(movie_listings)

    puts "Found #{ranking.positions.size} movies"

    print_ranking(ranking, number_of_movies)
  end

  private

  # TODO: move all of this stuff to separate classes

  def self.fetch_movies(username)
    movies_url = "http://www.filmweb.pl/user/#{username}/films/wanna-see"

    doc = Nokogiri::HTML(open(movies_url)) do |config|
      config.noent
    end

    raw_movies = doc.css(".wantToSeeSee td").each_slice(2)

    ranking = Ranking.new

    raw_movies.each do |raw_movie|
      movie_cell, score_cell = raw_movie

      title_attribute = movie_cell.attributes.fetch('sorttable_customkey')

      movie_title = title_attribute.value

      movie_link = movie_cell.at_css('a')

      movie_id = movie_link.attributes.fetch('href').value
      movie_id = movie_id[1..-1] # Cut the first char, which is /

      movie_score = Integer(score_cell.attributes.fetch('sorttable_customkey').value)

      movie = Movie.new(movie_id, movie_title)

      ranking.add_position movie, movie_score
    end

    if ranking.positions.to_a.empty?
      raise "#{username} has no movies that they would like to watch"
    end

    ranking
  end

  def self.create_ranking(movie_rankings)
    all_movies = movie_rankings.map { |ranking| ranking.positions.map(&:item) }.flatten.uniq

    ranking = Ranking.new

    all_movies.map do |movie|
      ranking.add_position movie, score_movie(movie, movie_rankings)
    end

    ranking
  end

  def self.score_movie(movie, rankings)
    scores_sum = rankings.map { |ranking| ranking.find_position(movie.id) { BlankPosition.new }.score }.inject(:+)

    # Bonus is the number of users who also want to watch a particular movie
    # times the number of users.
    bonus = rankings.count { |ranking| ranking.find_position(movie.id) { nil } } / rankings.size.to_f

    scores_sum * bonus
  end

  def self.print_ranking(ranking, number_of_movies = 20)
    string_format = "%-2s %-32s %4s %s"

    puts string_format % %w(# Title Score URL)

    ranking.positions_with_ordinal(number_of_movies) do |position, ordinal|
      puts string_format % [ordinal, position.item.title, position.score.round(2), position.item.url]
    end

    nil
  end
end
