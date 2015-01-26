require 'byebug'

class Tile
  attr_accessor :has_bomb, :flagged, :revealed

  def initialize()
  #  @board = board
    @has_bomb = false
    @flagged = false
    @revealed = false

  end

end

class Board
  attr_reader :tiles

  def initialize
    tile_row = []
    9.times do
      tile_row << Tile.new
    end

    @tiles = []
    9.times do
      @tiles << tile_row.dup
    end


  end

  def seed_bombs
    bomb_count = 0
    #debugger
    while bomb_count < 10
      current_tile = self.tiles.sample.sample.sample
      if current_tile.has_bomb
        next
      else
        current_tile.has_bomb = true
        puts current_tile
        bomb_count += 1
        p bomb_count
      end
    end
  end

  def [] (x,y)
    self.tiles[x][y]


  end

end
