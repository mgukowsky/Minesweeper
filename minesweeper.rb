class Tile
  attr_accessor :has_bomb, :flagged, :revealed

  def initialize(board)
    @board = board
    @has_bomb = false
    @flagged = false
    @revealed = false

  end

end

class Board

  def initialize
    tile_row = []
    9.times do
      tile_row << Tile.new(self)
    end

    @tiles = []
    9.times do
      @tiles << tile_row.dup
    end


    end
  end


end
