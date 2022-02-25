module CleverAIStrategy
  # Evaluates the board with a recursive algorithm and
  # provides an optimal strategy for achieving a higher score.
  def evaluate_score(player)
    case find_winner
    when player then return 1
    when opponent_of(player) then return -1
    end

    # no winner so far
    return 0 if self.full? # no winner + board is full = draw game

    # start recursion
    all_possible_scores =
      empty_cells.map do |cell_index|
        new_board = play_move(player, cell_index)
        new_board.evaluate_score(opponent_of(player)) * -1
      end
    all_possible_scores.max
  end

  def analyse_each_move(player)
    empty_cells.map do |cell_index|
      new_board = play_move(player, cell_index)
      score = new_board.evaluate_score(opponent_of(player)) * -1
      yield cell_index, score if block_given?
      [cell_index, score]
    end.to_h
  end

  def suggest_next_move(player)
    available_moves = self.empty_cells

    case available_moves.length
    when 0 then nil
    when 1 then available_moves[0]
    when 9 then 0
    end

    # when having 2 ~ 8 empty cells, find the move with best score
    moves_and_scores = analyse_each_move(player) do |move, score|
      return move if score == 1
    end

    best_move, _best_score = moves_and_scores.max_by { |_move, score| score }
    best_move
  end
end

class CleverAI < Board
  include CleverAIStrategy
end
