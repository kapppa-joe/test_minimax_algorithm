class CLIView
  # =====================
  # === CLI view logic
  # =====================
  def make_grid(input_string)
    lines = []
    lines << horizontal_line
    [0, 3, 6].each do |i|
      row = input_string[i, 3]
      lines << make_row(row)
    end
    lines << horizontal_line

    lines.join("\n")
  end

  def horizontal_line
    ' -------'
  end

  def make_row(row)
    a, b, c = row.tr('012', '.XO').chars
    "| #{a} #{b} #{c} |"
  end
end
