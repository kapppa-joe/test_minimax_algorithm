require 'cli_user_interaction'
require 'cli_view'

describe CliUserInteraction do
  let(:cli) { described_class.new }

  describe '#ask_for_player_move' do
    before(:each) do
      @cli = cli
      allow(@cli).to receive(:gets).and_return('1')
    end

    it 'asks user for input' do
      expect(@cli).to receive(:gets)

      @cli.ask_for_player_move
    end

    it "prints a message 'Please input your next move (1 - 9)'" do
      expected_msg = a_string_including('Please input your next move (1 - 9)')
      expect { @cli.ask_for_player_move }.to output(expected_msg).to_stdout
    end

    it 'returns an integer' do
      output = @cli.ask_for_player_move
      expect(output).to be_an(Integer)
    end

    it 'returns the integer that user has inputed' do
      test_number = rand(1..9)
      allow(@cli).to receive(:gets).and_return(test_number.to_s)

      output = @cli.ask_for_player_move
      expect(output).to eql test_number
    end

    it 'asks user to input again if the number is out of range 1-9' do
      user_inputs = ['0', '10', '5']
      allow(@cli).to receive(:gets).and_return(*user_inputs)
      expect(@cli).to receive(:gets).exactly(3).times
      @cli.ask_for_player_move
    end

    it 'prints a message "Sorry, can you please input again?" if the number is out of range 1-9' do
      user_inputs = ['0', '10', '5']
      allow(@cli).to receive(:gets).and_return(*user_inputs)
      expected_msg = a_string_including('Sorry, can you please input again?')

      expect { @cli.ask_for_player_move }.to output(expected_msg).to_stdout
    end

    it 'repeatedly ask the user for input until it gets a number within 1-9' do
      user_inputs = ['0', '10', 'abc', 'exit', 'quit', ':q', ':q!', 'hey', 'let me out', 'stop it', '1']
      allow(@cli).to receive(:gets).and_return(*user_inputs)

      expect(@cli).to receive(:gets).exactly(user_inputs.length).times
      @cli.ask_for_player_move
    end
  end

  describe '#print_board' do
    before(:each) do 
      @presenter = CLIView.new
      @cli = described_class.new(presenter: @presenter)
    end

    it 'calls the #make_grid method of presenter' do
      expect(@presenter).to receive(:make_grid)
      @cli.print_board('000000000')
    end

    it 'prints the output of #make_grid' do
      dummy_message = 'hello world'
      allow(@presenter).to receive(:make_grid).and_return(dummy_message)

      expected_msg = a_string_including(dummy_message)
      expect { @cli.print_board('') }.to output(expected_msg).to_stdout
    end

    it 'by default, prints a ascii game board represention of the given string' do
      input_string = '012120201'
      ascii_game_board =
        <<~GRID.chomp
           -------
          | . X O |
          | X O . |
          | O . X |
           -------
        GRID
      expected_msg = a_string_including(ascii_game_board)
      expect { @cli.print_board(input_string) }.to output(expected_msg).to_stdout
    end
  end
end
