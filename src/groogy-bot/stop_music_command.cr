class StopMusicCommand < Command
  def initialize
    super "!stopmusic", /^!stopmusic */, "for broadcaster & moderators only"
  end

  def has_permission?(msg)
    usr = User.new msg
    usr.broadcaster? || usr.moderator?
  end

  def execute(bot, client, msg, match)
    response = Response.new msg, client
    bot.stop_queue
    response.reply "stopped music service"
  end
end