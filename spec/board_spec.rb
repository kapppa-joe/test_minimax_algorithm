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
      copied_board = board.copy

      expect(copied_board.to_s).to eql '120120120'
      expect(board.object_id).not_to eql copied_board.object_id
    end

    it 'do not share change between original board and copied board' do
      board = Board.new('120120120')
      copied_board = board.copy

      board = board.play_move(2, 2)
      copied_board = copied_board.play_move(2, 8)

      expect(board.to_s).not_to eql copied_board.to_s
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

  describe '#play_move' do
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
        it "first input = #{input.inspect}" do
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

  describe '#opponent_of' do
    it 'return 2 when input is 1' do
      expect(board.opponent_of(1)).to eql 2
    end

    it 'return 1 when input is 2' do
      expect(board.opponent_of(2)).to eql 1
    end

    it 'raise InvalidInputError if input is not 1 or 2' do
      test_cases = [-1, 3, 4, nil, true, false, '0', '1', '2', 12, 'a', [0], [1]]
      test_cases.each do |invalid_input|
        expect { board.opponent_of(invalid_input) }.to raise_error(InvalidInputError)
      end
    end
  end

  describe '#empty?' do
    it 'return true for a new board' do
      expect(board.empty?).to be true
    end

    it 'return false if the board is not all zeros' do
      expect(Board.new('100000000').empty?).to be false
      expect(Board.new('020000000').empty?).to be false
      expect(Board.new('120010020').empty?).to be false
    end
  end

  describe '#full?' do
    it 'return false for an empty board' do
      expect(board.full?).to be false
    end

    it 'return true for a board with nine 1s' do
      board = Board.new('111111111')
      expect(board.full?).to be true
    end

    it 'return true for a board with nine 2s' do
      board = Board.new('222222222')
      expect(board.full?).to be true
    end

    it 'return false if 2nd cell of the board is "0"' do
      board = Board.new('101111111')
      expect(board.full?).to be false
    end

    it 'return false if any cell of the board is "0"' do
      test_cases = %w[
        110222111
        121012121
        210101212
        111222101
        111220111
        111222110
        111202011
      ]
      test_cases.each do |input_string|
        board = Board.new(input_string)
        expect(board.full?).to be false
      end
    end
  end

  describe '#empty_cells' do
    it 'return an array' do
      expect(board.empty_cells).to be_an(Array)
    end

    it 'return an empty array when board is fully occupied' do
      board = Board.new('121212121')
      expect(board.empty_cells).to eql []
    end

    it 'return [0] when only the first cell of board is empty' do
      board = Board.new('012121212')
      expect(board.empty_cells).to eql [0]
    end

    it 'return [0, 1, 2, ... 8] for an empty board' do
      expect(board.empty_cells).to eql (0..8).to_a
    end

    it 'return [i] when only the ith cell of board is empty' do
      9.times do |i|
        string = '121212121'
        string[i] = '0'
        board = Board.new(string)
        expect(board.empty_cells).to eql [i]
      end
    end

    it 'return an array of all indices of zeros in the board' do
      test_cases = {
        '101020201' => [1, 3, 5, 7],
        '012022011' => [0, 3, 6],
        '000111222' => [0, 1, 2],
        '010200201' => [0, 2, 4, 5, 7]
      }

      test_cases.each do |input_string, expected_output|
        board = Board.new(input_string)
        expect(board.empty_cells).to eql expected_output
      end
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

    it 'return a string representation of diagonal in the board
      when given number 0 (for left-to-right) or 1 (for right-to-left)' do
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

  describe '#for_each_rows_columns_diagonals' do
    it 'yield 8 times' do
      expect do |block|
        board.for_each_rows_columns_diagonals(&block)
      end.to yield_control.exactly(8).times
    end

    it 'yield with string "000" for 8 times for an empty board' do
      expected_args = ['000'] * 8

      expect do |block|
        board.for_each_rows_columns_diagonals(&block)
      end.to yield_successive_args(*expected_args)
    end

    it 'yield with each row, column, diagonal of the board' do
      board = Board.new('012210102')
      expected_args = [
        '012', '210', '102', # each row
        '021', '110', '202', # each column
        '012', '211' # two diagonals
      ]

      expect do |block|
        board.for_each_rows_columns_diagonals(&block)
      end.to yield_successive_args(*expected_args)
    end
  end

  describe '#check_three_in_a_row' do
    it 'return integer 1 when given string "111"' do
      expect(board.check_three_in_a_row('111')).to eql 1
    end

    it 'return integer 2 when given string "222"' do
      expect(board.check_three_in_a_row('222')).to eql 2
    end

    it 'return nil for all other cases' do
      test_cases = [0, 1, 2]
                   .repeated_permutation(3)
                   .to_a
                   .map(&:join)
      test_cases -= %w[111 222]

      test_cases.each do |three_cells|
        expect(board.check_three_in_a_row(three_cells)).to eql nil
      end
    end
  end

  describe '#find_winner' do
    it 'return nil when board is empty' do
      expect(board.find_winner).to be_nil
    end

    it 'return 1 when first row is "111"' do
      board = Board.new('111000000')
      expect(board.find_winner).to eql 1
    end

    it 'return 2 when first row is "222"' do
      board = Board.new('222000000')
      expect(board.find_winner).to eql 2
    end

    it 'return 1 when the board is "111222000"' do
      # for performance reason, deliberately not to check for invalid boards here
      board = Board.new('111222000')
      expect(board.find_winner).to eql 1
    end

    describe "return the winner's player number if the game has been won" do
      test_cases = {
        '111220000' => 1,
        '222111000' => 2,
        '000111222' => 1,
        '000222111' => 2,
        '120120120' => 1,
        '021021021' => 2,
        '122112201' => 1,
        '112021221' => 2,
        '110110112' => 1,
        '112022211' => 2,
        '122022200' => 2,
        '201212211' => 2,
        '221001201' => 1
      }
      test_cases.each do |input_string, expected_output|
        it "board: #{input_string}, winner: #{expected_output}" do
          board = Board.new(input_string)
          expect(board.find_winner).to eql expected_output
        end
      end
    end

    describe 'return nil when no one has won on the board' do
      test_cases = %w[
        021012021
        001120100
        121122202
        210221010
        210120201
        100122221
        012200112
        020101121
        002010010
        012101221
        010221202
        101100001
      ]
      test_cases.each do |input_string|
        it "board: #{input_string}" do
          board = Board.new(input_string)
          expect(board.find_winner).to be_nil
        end
      end
    end
  end
end
