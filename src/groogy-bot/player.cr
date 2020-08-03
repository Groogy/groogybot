module Player
  @@player = "%any"

  def self.player=(player)
    @@player = player
  end

  def self.status
    `playerctl --player=#{@@player} status`.chomp
  end

  def self.currently_playing
    `playerctl --player=#{@@player} metadata --format "{{ artist }} - {{ title }}"`
  end

  def self.open(path)
    `playerctl --player=#{@@player} open "#{path}"`
  end

  def self.play
    `playerctl --player=#{@@player} play`
  end

  def self.stop
    `playerctl --player=#{@@player} stop`
  end
end