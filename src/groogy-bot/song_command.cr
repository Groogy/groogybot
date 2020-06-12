class SongCommand < Command
  def initialize
    super "!song", /^!song */, "show what song is currently being played."
  end

  def execute(bot, client, msg, match)
    song_info = Player.currently_playing
    client.reply msg, "Currently playing: #{song_info}"
  end
end