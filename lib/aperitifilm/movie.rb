module Aperitifilm
  FILMWEB_URL = 'http://www.filmweb.pl'.freeze

  class Movie < Struct.new(:id, :title)
    def url
      "#{Aperitifilm::FILMWEB_URL}/#{id}"
    end

    def ==(other_movie)
      self.id == other_movie.id
    end
  end
end
