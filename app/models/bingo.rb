class Bingo < Game
  broadcasts

  OFS =  [["Regular HVD", "X..X..X.X...XX.XXXXX...XX"],["Little Dimond", ".......X...X.X...X......."], 
  ["Little Box", "......XXX..X.X..XXX......"], 
  ["I", "..X....X....X....X....X.."],  
  ["Large Diamond", "..X...X.X.X...X.X.X...X.."], 
  ["Corners", "X...X...............X...X"], 
  ["Cover All", "XXXXXXXXXXXXXXXXXXXXXXXXX"], 
  ["Cross", "..X..XXXXX..X....X....X.."], 
  ["Big Box", "XXXXXX...XX...XX...XXXXXX"]]

  # def viewers
  #   puts "I'VE CALLED VIEWER"
  #   broadcast_replace_later_to "bingo_#{self.id}", partial: 'bingos/bingo', locals:{bingo:self}
  # end
end