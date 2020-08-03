class SongCommand < Command
  def initialize
    super "!song", /^!song */, "show what song is currently being played."
  end

  def execute(bot, client, msg, match)
    response = Response.new msg, client
    song_info = Player.currently_playing
    response.reply "currently playing: #{song_info}"
  end
end