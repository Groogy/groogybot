class StopMusicCommand < Command
  def initialize
    super "!stopmusic", /^!stopmusic */, "for broadcaster & moderators only"
  end

  def has_permission?(msg)
    tags = msg.tags_list
    if tag = tags["badges"]?
      tag.includes?("broadcaster") || tag.includes?("moderator")
    else
      false
    end
  end

  def execute(bot, client, msg, match)
    bot.stop_queue
    client.reply msg, "stopped music service"
  end
end