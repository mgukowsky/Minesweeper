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

end
