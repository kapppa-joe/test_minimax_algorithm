class CLIView
  # =====================
  # === CLI view logic
  # =====================
  def display_grid(input_string)
    lines = []
    lines << horizontal_line
    [0, 3, 6].each do |i|
      row = input_string[i, 3]
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
