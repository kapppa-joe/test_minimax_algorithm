require 'cli_view'

describe CLIView do
  let(:cli_view) { described_class.new }
  describe '#display_grid' do
    it 'return a string of the cli_view as a pretty looking grid' do
      input_string = '000000000'
      actual_output = cli_view.display_grid(input_string)
      expected_output =
        <<~GRID.chomp
           -------
          | . . . |
          | . . . |
          | . . . |
           -------
        GRID

      expect(actual_output).to eql expected_output
    end

    it 'display 1 as X in grid' do
      input_string = '111111111'
      actual_output = cli_view.display_grid(input_string)
      expected_output =
        <<~GRID.chomp
           -------
          | X X X |
          | X X X |
          | X X X |
           -------
        GRID

      expect(actual_output).to eql expected_output
    end

    test_cases = {
      '012012012' =>
        " -------\n"  \
        "| . X O |\n" \
        "| . X O |\n" \
        "| . X O |\n" \
        ' -------',

      '210001212' =>
        " -------\n"  \
        "| O X . |\n" \
        "| . . X |\n" \
        "| O X O |\n" \
        ' -------'
    }

    test_cases.each do |input_string, expected_output|
      it "display the cli_view in a grid which represent 0 1 2 with symbol . X O
        correspondingly, input string: #{input_string}" do
        actual_output = cli_view.display_grid(input_string)

        expect(actual_output).to eql expected_output
      end
    end
  end

  describe '#horizontal_line' do
    it 'return a line consist of 1 whitespace and 7 dashes' do
      expect(cli_view.horizontal_line).to eq ' -------'
    end
  end

  describe '#display_row' do
    it 'take a string and return a string' do
      expect(cli_view.display_row('000')).to be_a(String)
    end

    it 'if given "000", return a string representation of an empty row' do
      input = '000'
      expected_output = '| . . . |'

      expect(cli_view.display_row(input)).to eql expected_output
    end

    test_cases = {
      '000' => '| . . . |',
      '111' => '| X X X |',
      '222' => '| O O O |',
      '012' => '| . X O |',
      '120' => '| X O . |',
      '212' => '| O X O |'
    }

    test_cases.each do |input, expected_output|
      it "represent 0, 1, 2 with symbol ., X, O correspondingly, input: #{input}, expected output: #{expected_output}" do
        expect(cli_view.display_row(input)).to eql expected_output
      end
    end
  end
end
