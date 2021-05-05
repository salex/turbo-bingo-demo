class Bingo < Game
  broadcasts
  # after_commit :viewers

  def self.current
    self.find_by(status:'current')
  end

  def viewers
    puts "I'VE CALLED VIEWER"
    broadcast_replace_later_to "bingo_#{self.id}", partial: 'bingos/bingo', locals:{bingo:self}
  end
end