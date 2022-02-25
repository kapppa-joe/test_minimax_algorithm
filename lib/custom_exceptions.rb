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
