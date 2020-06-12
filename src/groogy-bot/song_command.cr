class SongCommand < Command
  def initialize
    super "!song", /^!song */, "show what song is currently being played."
  end

  def execute(bot, msg, match)
    song_info = `playerctl metadata --format "{{ artist }} - {{ title }}"`
    bot.reply msg, "Currently playing: #{song_info}"
  end
end