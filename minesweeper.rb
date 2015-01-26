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
      next unless (x+x_diff).between?(0,8)
      next unless (y+y_diff).between?(0,8)
      neighbor = self[x+x_diff,y+y_diff]
      if neighbor.has_bomb
        neighbor_bombs += 1
      end
    end
    neighbor_bombs
  end

  def neighbor_reveal_count(x,y)
    neighbor_revealed = 0
    DIRECTIONS.each do |direction|
      x_diff = direction[0]
      y_diff = direction[1]
      next unless (x+x_diff).between?(0,8)
      next unless (y+y_diff).between?(0,8)
      neighbor = self[x+x_diff,y+y_diff]
      if neighbor.revealed
        neighbor_revealed += 1
      end
    end
    neighbor_revealed
  end
end


class Minesweeper

  DIRECTIONS = [[0, 1],
  [1, 1],
  [1, 0],
  [1, -1],
  [0, -1],
  [-1, -1],
  [-1, 0],
  [-1, 1]]

  attr_accessor :board

  def initialize
    @board = Board.new
    @done = false
    @won = false
    @bomb_locations = []
    @flag_locations = []

  end

  def run
    puts "Welcome to Minesweeper"
    puts "Seeding bombs..."
    seed_bombs


    until @done
      display
      input = get_input
      update_board(input)
      p @flag_locations.sort
      p @bomb_locations.sort
      if @bomb_locations.sort == @flag_locations.sort && all_clear?
        @done = true
        @won = true
      end
    end
    if @won
      puts "CONGRATULATIONS, YOU WIN!!!"
    else
      puts "you lose :("
    end
    nil
  end

  def seed_bombs
    bomb_count = 0
    #debugger
    while bomb_count < 10
      x = (0..8).to_a.shuffle[0]
      y = (0..8).to_a.shuffle[0]
      p [x,y]
      current_tile = @board[x,y]
      unless current_tile.has_bomb
        current_tile.has_bomb = true
        @bomb_locations << [x, y]

        puts "bomb"
        bomb_count += 1


      end
    end
  end



  def display
    @board.tiles.each_with_index do |row, y|
      output_string = ""
      row.each_with_index do |tile, x|
          output_string += " #{get_symbol(x,y)}"
      end
      puts output_string.strip
    end
    nil

  end

  def get_input
    puts "What X coordinate do you want?"
    x = gets.chomp.to_i
    puts "What Y coordinate do you want?"
    y = gets.chomp.to_i
    puts "Enter R for reveal or F for flag."
    move_action = gets.chomp

    [x, y, move_action]
  end

  def update_board(input)
    x = input.shift
    y = input.shift
    action = input.shift

    if action == 'R'
      if @board[x,y].has_bomb
        finish_game
        @done = true
      else
        recursive_reveal(x,y)
      end
    else
      @board.flagged(x, y)
      @flag_locations << [x, y]
    end
  end

  def finish_game
    @board.tiles.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        unless @board[x,y].revealed
          @board[x,y].revealed = true
        end
      end
    end
    self.display
  end

  def recursive_reveal(x,y)
    # debugger

    if @board[x, y].revealed
      return nil
    end

    if @board.neighbor_bomb_count(x,y) > 0
      @board[x,y].revealed = true
      return nil
    end
    @board[x,y].revealed = true
    DIRECTIONS.each do |direction|
      x_diff = direction[0]
      y_diff = direction[1]
      next unless (x+x_diff).between?(0,8)
      next unless (y+y_diff).between?(0,8)

      recursive_reveal(x + x_diff, y + y_diff)
    end
    nil
  end

  def all_clear?
    @board.tiles.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        next if @board[x,y].flagged
        return false unless @board[x,y].revealed
      end
    end
    true
  end

  def get_symbol(x,y)
    temp_tile = @board[x,y]
    bomb_count = @board.neighbor_bomb_count(x,y)
    if temp_tile.revealed && temp_tile.has_bomb
      return "B"

    elsif bomb_count > 0 && @board[x,y].revealed

      return bomb_count.to_s

    elsif temp_tile.revealed
      return "_"

    elsif temp_tile.flagged
      return "F"


    else
      return "*"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  m = Minesweeper.new
  m.run
end
