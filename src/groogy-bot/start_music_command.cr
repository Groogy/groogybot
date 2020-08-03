class StartMusicCommand < Command
  def initialize
    super "!startmusic", /^!startmusic */, "for broadcaster & moderators only"
  end

  def has_permission?(msg)
    usr = User.new msg
    usr.broadcaster? || usr.moderator?
  end

  def execute(bot, client, msg, match)
    response = Response.new msg, client
    bot.start_queue
    response.reply "started playing your music :)"
  end
end