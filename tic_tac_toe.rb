class TicTacToe
  def initialize
    @end_condition = nil 
    @board = Board.new
    @player1 = Player.new
    @player2 = Player.new
  end

  def play
    while 1
      if @end_condition = @board.place_piece(@player1) || @end_condition = @board.place_piece(@player2)
        return @end_condition
      end
    end
  end
end

class Player
  @@player_count = 0
  attr_reader :piece, :name

  def initialize
    @@player_count += 1
    puts ("Player #{@@player_count}, enter your name:")
    @name = gets.chomp
    @@player_count == 1 ? @piece = 'X' : @piece = 'O'
    puts ("Hi #{@name}, your piece is #{@piece}")
  end

  def get_coordinates
    coordinates = []
    puts "#{@name}, provide coordinates 'row,column' starting at 0:"
    string = gets.chomp
    string.chars.each { |char| coordinates << char.to_i if  char =~ /[[:digit:]]/ } #wont properly fail for double digit inputs / more than 2 numbers. will just take first 2 integers provided.
    return coordinates    
  end
end

class Board
  def initialize 
    @board = Array.new(3) { ['-','-','-'] }
  end

  def place_piece(player)
    valid = false
    while valid == false
      coordinates = player.get_coordinates
      puts "current: #{coordinates}"
      unless board_check(coordinates)
        next
      end
      @board[coordinates[0]][coordinates[1]] = player.piece
     valid = true
    end
    display
    return check_end_condition(player)
  end

  private
  def board_check(coordinates)
    if coordinates[0].nil? || coordinates[1].nil?  #checks improperly entered coordinates
      puts 'invalid selection, please enter again. usage: integer,integer'
      return false
    elsif @board[coordinates[0]].nil? || @board[coordinates[0]][coordinates[1]].nil? #checks out of bounds coordinates
      puts 'selection out of range, please enter again. min 0,0 | max: 2,2'
      return false
    elsif @board[coordinates[0]][coordinates[1]] == 'X' || @board[coordinates[0]][coordinates[1]] == 'O' #checks if box taken
      puts 'box already taken, please enter again.'
      return false
    else
      true
    end
  end

  def display
    @board.each { |row| puts row.join(" | ") } 
  end

  def check_end_condition(player)
    if three_in_a_row(player)
      return "#{player.name} VICTORY!"
    elsif board_full
      return "cat's game!"
    else
      return false
    end
  end

  def three_in_a_row(player)
    @board.each do |row| #checks horizontal win condition.
      return true if row.all? { |box| box == player.piece }
    end
    @board.transpose.each do |column| #checks vertical win condition.
      return true if column.all? { |box| box == player.piece }
    end
    if @board[1][1] == player.piece && #checks diagonal win condition.
      ((@board[0][0] == player.piece && @board[2][2] == player.piece) || 
      (@board[0][2] == player.piece && @board [2][0] == player.piece))
      return true
    end 
    return false
  end

  def board_full
    @board.each do |row|
      row.each { |box| return false if box == '-' }
    end
    return true 
  end
end

game = TicTacToe.new
puts game.play