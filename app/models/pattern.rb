class Pattern < ApplicationRecord

  def pattern_to_rows
    # pattern is a 25 character string with space or x
    cols = [[],[],[],[],[]]
    # split pattern into 5 columns
    self.card.each_char.with_index do |c,i|
      cols[i%5] << c
    end
    # transpose the columns into rows
    cols.transpose
  end

end
