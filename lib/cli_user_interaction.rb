require 'cli_view'

class CliUserInteraction
  def initialize(args = {})
    @presenter = args[:presenter] || CLIView.new
  end

  def ask_for_player_move
    puts 'Please input your next move (1 - 9)'
    received_value = nil

    until (1..9).cover?(received_value) do
      puts 'Sorry, can you please input again?'
      received_value = gets.chomp.to_i
    end
    received_value
  end

  def print_board(input_string)
    puts @presenter.make_grid(input_string)
  end
end
