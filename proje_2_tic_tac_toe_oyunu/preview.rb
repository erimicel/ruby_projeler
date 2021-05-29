class Player
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end
# sembol secmeli yapilabilir.

class Board
  WIN_COMBINATIONS = [ 
    [0,1,2], # ust_satir
    [3,4,5], # orta_satir
    [6,7,8], # alt_satir
    [0,3,6], # sol_sutun
    [1,4,7], # orta_sutun
    [2,5,8], # sag_sutun
    [0,4,8], # sol_capraz 
    [6,4,2]  # sag_capraz
  ].freeze

  attr_reader :cells

  def initialize
    @cells = [1,2,3,4,5,6,7,8,9]
    puts "\n\nOyun icin alan hazirlaniyor..."
    sleep(1)
    display_board
  end

  def display_board
    puts "\n\n"
    puts "\t #{cells[0]} | #{cells[1]} | #{cells[2]} "
    puts "\t-----------"
    puts "\t #{cells[3]} | #{cells[4]} | #{cells[5]} "
    puts "\t-----------"
    puts "\t #{cells[6]} | #{cells[7]} | #{cells[8]} "
    puts "\n\n"
  end

  def valid_move?(number)
    cells[number - 1] == number
  end

  def update_board(number, symbol)
    @cells[number] = symbol
  end

  def full?
    cells.all? { |cell| cell =~ /[^0-9]/ }
  end

  def game_over?
    WIN_COMBINATIONS.any? do |combo|
      [cells[combo[0]], cells[combo[1]], cells[combo[2]]].uniq.length == 1
    end
  end
end

class Game
  attr_accessor :p1, :p2, :current_player, :board
  
  def initialize
    @p1 = nil
    @p2 = nil
    @current_player = nil
    @board = nil
  end

  def create_players
    puts "1.ci oyuncunun ismi (X):"
    name1 = gets.chomp
    self.p1 = Player.new(name1, "X")
    puts "2.ci oyuncunun ismi (O):"
    name2 = gets.chomp
    self.p2 = Player.new(name2, "O")
  end

  def setup_game
    puts "Tic Tac Toe oyununa hosgeldiniz! \n\n"
    create_players
    roll_dice
    self.board = Board.new
    play_game
    end_game
    repeat_game
  end

  def roll_dice
    puts "\nOyuna baslayacak kisi seciliyor...\n"
    #0 player1, 1 player2
    puts "#{self.p1.name} icin zar atiliyor..."
    n1 = rand(1..6)
    sleep(2)
    puts n1
    puts "#{self.p2.name} icin zar atiliyor..."
    sleep(2)
    n2 = rand(1..6)
    puts n2
    if n1 > n2
      puts "\n#{self.p1.name} (X) oyuna baslayacak."
      self.current_player = self.p1
    else
      puts "\n#{self.p2.name} (O) oyuna baslayacak."
      self.current_player = self.p2
    end
  end

  def play_game
    until board.full?
      cell = player_turn(current_player)
      self.board.update_board(cell - 1, current_player.symbol)
      self.board.display_board
      break if self.board.game_over?
      if self.current_player == self.p1
        self.current_player = self.p2
      else
        self.current_player = self.p1
      end
    end
  end

  def player_turn(player)
    puts "#{player.name}, Lutfen rakam giriniz (1-9) gecerli olan sembol: '#{player.symbol}'"
    number = gets.chomp.to_i
    return number if self.board.valid_move?(number)
    # 31 numarasi kirmizidir 32 yesil 33 sari olacaktir 34 mavi
    puts "\e[31mHata: Lutfen gecerli bir sayi giriniz (1-9)\e[0m"
    player_turn(current_player)
  end

  def end_game
    if board.game_over?
      puts "\n\e[32mOyun bitti. Tebrikler Kazanan: #{current_player.name}\e[0m"
    else
      puts "\nBerabere bitti."
    end
  end

  def repeat_game
    puts "\nTekrar oynamak istiyormusunuz? (y/n)"
    repeat_input = gets.chomp.downcase
    if repeat_input == 'y'
      self.setup_game 
    else
      puts "Oynadiginiz icin tesekkurler, cikis yapiliyor...\n"
    end
  end
end

game = Game.new
game.setup_game
