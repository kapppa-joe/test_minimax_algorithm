require 'board'

describe Board do
  let(:board) { described_class.new }

  describe '::new' do
    it 'return a new instance of Board' do
      board = Board.new
      expect(board).to be_a(Board)
    end

    it 'return a board with 9 zeros by default' do
      board = Board.new
      expect(board.to_s).to eql '000000000'
    end

    it 'if given a string of length 9, return a board represented by that string' do
      board = Board.new('111222000')
      expect(board.to_s).to eql '111222000'
    end

    it 'raise an InvalidInputError if given a string of length not equals to 9' do
      expect { Board.new('') }.to raise_error(InvalidInputError)
      expect { Board.new('00000000') }.to raise_error(InvalidInputError)
      expect { Board.new('0000000000') }.to raise_error(InvalidInputError)
    end

    it 'raise an InvalidInputError if input_string include any char which is not 0, 1 or 2' do
      expect { Board.new('123000000') }.to raise_error(InvalidInputError)
      expect { Board.new('A00000000') }.to raise_error(InvalidInputError)
    end
  end

  describe '#copy' do
    it 'returns a board' do
      board_copy = board.copy
      expect(board_copy).to be_a(Board)
    end

    it 'returns a copy of the same board, with a different object id' do
      board = Board.new('120120120')
      board_copy = board.copy

      expect(board_copy.to_s).to eql '120120120'
      expect(board.object_id).not_to eql board_copy.object_id
    end
  end

  describe '#to_s' do
    it 'return a string' do
      expect(board.to_s).to be_a(String)
    end

    it 'convert the board to a simple string representation' do
      board = Board.new
      expect(board.to_s).to eql '000000000'

      board2 = Board.new('120120120')
      expect(board2.to_s).to eql '120120120'
    end
  end

  describe 'play_move' do
    it 'return a board' do
      output = board.play_move(1, 2)

      expect(output).to be_a(Board)
    end

    it 'return a NEW board' do
      output = board.play_move(1, 2)

      expect(output.object_id).not_to eql board.object_id
    end

    it 'do not modify the original board' do
      original_board_string = board.to_s.freeze
      board.play_move(1, 2)
      expect(board.to_s).to eql original_board_string
    end

    it 'return a board of "100000000" when given (1, 0) and a empty board' do
      output = board.play_move(1, 0)
      expect(output.to_s).to eql '100000000'
    end

    it 'return a board of "200000000" when given (2, 0) and a empty board' do
      output = board.play_move(2, 0)
      expect(output.to_s).to eql '200000000'
    end

    describe 'raise an InvalidInputError if the first input was not integer 1 or 2' do
      invalid_inputs = [
        '1', '2', 0, nil, 3, 4, '12', '01', '11', '22', 'abc', [1], [2]
      ]
      invalid_inputs.each do |input|
        it ", first input = #{input.inspect}" do
          expect { board.play_move(input, 0) }.to raise_error(InvalidInputError)
        end
      end
    end

    describe 'raise an InvalidInputError if the second input was not in range 0..8' do
      invalid_inputs = [
        '1', '2', -1, nil, 9, 10, '12', '01', '11', '22', 'abc', [1], [2]
      ]

      invalid_inputs.each do |input|
        it ", second input = #{input.inspect}" do
          expect { board.play_move(1, input) }.to raise_error(InvalidInputError)
        end
      end
    end

    describe 'it insert the 1st input (player number) at the position of 2nd input (cell_index)' do
      (1..2).each do |player_number|
        (0..8).each do |cell_index|
          it "player_number: #{player_number}, cell_index: #{cell_index}" do
            new_board = board.play_move(player_number, cell_index)
            expect(new_board.to_s[cell_index]).to eql player_number.to_s
          end
        end
      end
    end

    it 'raises OccupiedCellError if the cell at cell_index was already taken' do
      board = Board.new('100000000')
      expect { board.play_move(2, 0) }.to raise_error(OccupiedCellError, 'cell 0 was already taken')
    end
  end

  describe '#row' do
    it 'take an integer and return a string' do
      expect(board.row(0)).to be_a(String)
    end

    it 'return "000" when the board is empty and given number 0' do
      expect(board.row(0)).to eql '000'
    end

    it 'return a string representation of the first row in the board when given number 0' do
      board = Board.new('012120201')
      expect(board.row(0)).to eql '012'

      board2 = Board.new('210120201')
      expect(board2.row(0)).to eql '210'
    end

    it 'return a string representation of the nth row in the board when given number n' do
      board = Board.new('012120201')
      expect(board.row(0)).to eql '012'
      expect(board.row(1)).to eql '120'
      expect(board.row(2)).to eql '201'
    end

    describe 'raise InvalidInputError when given an input not in range 0..2' do
      test_cases = [-1, 3, 4, nil, true, false, '0', '1', '2', 12, 'a', [0], [1]]
      test_cases.each do |input|
        it "input: #{input.inspect}" do
          expect { board.row(input) }.to raise_error(InvalidInputError)
        end
      end
    end
  end

  describe '#column' do
    it 'take an integer and return a string' do
      expect(board.column(0)).to be_a(String)
    end

    it 'return "000" when the board is empty and given number 0' do
      expect(board.column(0)).to eql '000'
    end

    it 'return a string representation of the first column in the board when given number 0' do
      board = Board.new('111222000')
      expect(board.column(0)).to eql '120'

      board2 = Board.new('120002001')
      expect(board2.column(0)).to eql '100'
    end

    it 'return a string representation of the nth column in the board when given number n' do
      board = Board.new('111202011')
      expect(board.column(0)).to eql '120'
      expect(board.column(1)).to eql '101'
      expect(board.column(2)).to eql '121'
    end

    describe 'raise InvalidInputError when given an input not in range 0..2' do
      test_cases = [-1, 3, 4, nil, true, false, '0', '1', '2', 12, 'a', [0], [1]]
      test_cases.each do |input|
        it "input: #{input.inspect}" do
          expect { board.column(input) }.to raise_error(InvalidInputError)
        end
      end
    end
  end

  describe '#diagonal' do
    it 'take an integer and return a string' do
      expect(board.diagonal(0)).to be_a(String)
    end

    it 'return "000" when the board is empty and given number 0' do
      expect(board.diagonal(0)).to eql '000'
    end

    it 'return a string representation of the left-to-right diagonal in the board when given number 0' do
      board = Board.new('111222000')
      expect(board.diagonal(0)).to eql '120'

      board2 = Board.new('120002001')
      expect(board2.diagonal(0)).to eql '101'
    end

    it 'return a string representation of the nth diagonal in the board when given number n' do
      board = Board.new('120120120')
      expect(board.diagonal(0)).to eql '120'
      expect(board.diagonal(1)).to eql '021'
    end

    describe 'raise InvalidInputError when given an input not in range 0..1' do
      test_cases = [-1, 2, 3, 4, true, false, nil, '0', '1', '2', 12, 'a', [0], [1]]
      test_cases.each do |input|
        it "input: #{input.inspect}" do
          expect { board.diagonal(input) }.to raise_error(InvalidInputError)
        end
      end
    end
  end

  # ================================================
  # === minimax logic, to be extracted out later ===
  # ================================================

  describe '::score_board' do
    it 'returns an integer' do
      output = described_class.score_board('111111111', 1)
      expect(output).to be_an(Integer)
    end

    it 'returns +1 when given board = "111000000" and player = 1' do
      output = described_class.score_board('111000000', 1)
      expect(output).to eql 1
    end

    it 'returns -1 when given board = "111000000" and player = 2' do
      output = described_class.score_board('111000000', 2)
      expect(output).to eql(-1)
    end

    it 'returns +1 when given board = "222000000" and player = 2' do
      output = described_class.score_board('222000000', 2)
      expect(output).to eql 1
    end
  end

  # =================================================
  # === CLI view logic, to be extracted out later ===
  # =================================================


  describe 'CLI view' do
    describe '#display_grid' do
      it 'return a string of the board as a pretty looking grid' do
        expected_output =
          <<~GRID.chomp
             -------
            | . . . |
            | . . . |
            | . . . |
             -------
          GRID

        expect(board.display_grid).to eql expected_output
      end

      it 'display 1 as X in grid' do
        board = Board.new('111111111')
        expected_output =
          <<~GRID.chomp
             -------
            | X X X |
            | X X X |
            | X X X |
             -------
          GRID

        expect(board.display_grid).to eql expected_output
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

      test_cases.each do |input_string, expected_outout|
        it "display the board in a grid which represent 0 1 2 with symbol . X O correspondingly, input string: #{input_string}" do
          board = Board.new(input_string)
          actual_output = board.display_grid

          expect(actual_output).to eql expected_outout
        end
      end
    end

    describe '#horizontal_line' do
      it 'return a line consist of 1 whitespace and 7 dashes' do
        expect(board.horizontal_line).to eq ' -------'
      end
    end

    describe '#display_row' do
      it 'take a string and return a string' do
        expect(board.display_row('000')).to be_a(String)
      end

      it 'if given "000", return a string representation of an empty row' do
        input = '000'
        expected_output = '| . . . |'

        expect(board.display_row(input)).to eql expected_output
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
          expect(board.display_row(input)).to eql expected_output
        end
      end
    end
  end
end
