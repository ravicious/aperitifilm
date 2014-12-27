module Aperitifilm
  class RankingPosition
    include Comparable

    attr_reader :item, :score

    def initialize(item, score)
      @item = item
      @score = Float(score)
    end

    def <=>(other_position)
      (self.score <=> other_position.score) * -1
    end
  end
end
