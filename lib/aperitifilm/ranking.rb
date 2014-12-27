require_relative './ranking_position.rb'

module Aperitifilm
  class Ranking
    PositionNotFound = Class.new(KeyError)
    PositionAlreadyExists = Class.new(RuntimeError)

    def initialize
      @positions = {}
    end

    def positions(limit = @positions.size)
      return enum_for(:positions, limit) unless block_given?

      limit = Integer(limit)

      @positions.values.sort.take(limit).each do |position|
        yield position
      end
    end

    def positions_with_ordinal(limit)
      return enum_for(:positions_with_ordinal) unless block_given?

      positions(limit).each_with_index do |position, index|
        yield position, index + 1
      end
    end

    def find_position(id)
      @positions.fetch(id) do
        if block_given?
          yield id
        else
          raise PositionNotFound, "Couldn't find a position with ID '#{id}'."
        end
      end
    end

    def add_position(item, score)
      if @positions[item.id]
        raise PositionAlreadyExists, "Position with an item with ID '#{item.id}' already exists."
      else
        @positions[item.id] = RankingPosition.new(item, score)
      end
    end
  end
end
