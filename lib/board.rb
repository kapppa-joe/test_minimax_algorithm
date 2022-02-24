# frozen_string_literal: true

class InvalidInputError < StandardError
  MESSAGE = 'Cannot process that input value'
  def initialize(msg = MESSAGE)
    super
  end
end
class OccupiedCellError < InvalidInputError
  MESSAGE = 'Sorry, the cell was already taken'
  def initialize(msg = MESSAGE)
    super
  end
end

class Board
  def initialize(input_string = '000000000')
    if input_string.size != 9 || contain_invalid_char(input_string)
      raise InvalidInputError
    end

    @board = input_string
  end

  def contain_invalid_char(input_string)
    invalid_chars = input_string.chars.difference(%w[0 1 2])
    !invalid_chars.empty?
  end

  def copy
    Board.new(@board)
  end

  def to_s
    @board
  end

  def play_move(player, cell_index)
    raise InvalidInputError if player != 1 && player != 2
    raise InvalidInputError unless (0..8).cover?(cell_index)

    if @board[cell_index] != '0'
      raise OccupiedCellError, "cell #{cell_index} was already taken"
    end

    new_board_string = @board[0, 9]
    new_board_string[cell_index] = player.to_s
    Board.new(new_board_string.freeze)
  end

  # =============================================
  # === game logic, to be extracted out later ===
  # =============================================

  def row(row_number)
    raise InvalidInputError unless (0..2).cover?(row_number)

    start_index = row_number * 3
    @board[start_index, 3]
  end

  def column(column_number)
    raise InvalidInputError unless (0..2).cover?(column_number)

    start_index = column_number
    @board[start_index] + @board[start_index + 3] + @board[start_index + 6]
  end

  def diagonal(num)
    # 0 for left-to-right, 1 for right-to-left
    raise InvalidInputError unless (0..1).cover?(num)

    if num.zero?
      @board[0] + @board[4] + @board[8]
    else
      @board[2] + @board[4] + @board[6]
    end
  end

  def for_all_rows_columns_diagonals
    3.times { |i| yield row(i) }
    3.times { |i| yield column(i) }
    2.times { |i| yield diagonal(i) }
  end

  def check_three_in_a_row(three_cells)
    case three_cells
    when '111' then 1
    when '222' then 2
    end
  end

  def find_winner
    for_all_rows_columns_diagonals do |three_cells|
      winner = check_three_in_a_row(three_cells)
      return winner if winner
    end

    nil
  end

  def self.score_board(board, player)
    if player == board[0].to_i
      1
    else
      -1
    end
  end

  # =================================================
  # === CLI view logic, to be extracted out later ===
  # =================================================

  def display_grid
    lines = []
    lines << horizontal_line
    [0, 3, 6].each do |i|
      row = @board[i, 3]
      lines << display_row(row)
    end
    lines << horizontal_line

    lines.join("\n")
  end

  def horizontal_line
    ' -------'
  end

  def display_row(row)
    a, b, c = row.tr('012', '.XO').chars
    "| #{a} #{b} #{c} |"
  end
end
