require 'board'

describe Board do
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

  describe '::to_s' do
    it 'return a string' do
      board = Board.new
      expect(board.to_s).to be_a(String)
    end

    it 'convert the board to a simple string representation' do
      board = Board.new
      expect(board.to_s).to eql '000000000'

      board2 = Board.new('120120120')
      expect(board2.to_s).to eql '120120120'
    end
  end

  describe 'display_grid' do
    it 'return a string of the board as a pretty looking grid' do
      board = Board.new
      expected_output =
        '---------' \
        '| . . . |' \
        '| . . . |' \
        '| . . . |' \
        '---------' \

      expect(board.display_grid).to eql expected_output
    end
  end

  describe 'copy' do
    it 'returns a board' do
      board_copy = Board.new.copy
      expect(board_copy).to be_a(Board)
    end

    it 'returns a copy of the same board, with a different object id' do
      board = Board.new('120120120')
      board_copy = board.copy

      expect(board_copy.to_s).to eql '120120120'
      expect(board.object_id).not_to eql board_copy.object_id
    end
  end
end
