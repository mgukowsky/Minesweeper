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
  DIRECTIONS = [[0, 1],
                [1, 1],
                [1, 0],
                [1, -1],
                [0, -1],
                [-1, -1],
                [-1, 0],
                [-1, 1]]

  attr_reader :tiles


  def initialize
    @tiles = []
    tile_row = []
    9.times do
      tile_row = []
      9.times do
        tile_row << Tile.new
      end
      @tiles << tile_row
    end
  end

  def seed_bombs
    bomb_count = 0
    #debugger
    while bomb_count < 10
      x = (0..8).to_a.shuffle[0]
      y = (0..8).to_a.shuffle[0]
      p [x,y]
     current_tile = self[x,y]
     unless current_tile.has_bomb
        current_tile.has_bomb = true

        puts "bomb"
        bomb_count += 1


      end
    end
  end

  def [] (x,y)
    self.tiles[x][y]
  end

  def flagged(x, y)
    self[x, y].flagged = true
  end

  def revealed(x, y)
    self[x, y].revealed = true
  end

  def neighbor_bomb_count(x,y)
    neighbor_bombs = 0
    DIRECTIONS.each do |direction|
      x_diff = direction[0]
      y_diff = direction[1]
      next unless x+x_diff.between(-8,8)
      next unless y+y_diff.between(-8,8)
      neighbor = self[x+x_diff,y+y_diff]
      if neighbor.has_bomb
        neighbor_bombs += 1
      end
    end

    neighbor_bombs

  end

end
