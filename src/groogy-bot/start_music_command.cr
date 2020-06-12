class StartMusicCommand < Command
  def initialize
    super "!startmusic", /^!startmusic */, "for broadcaster & moderators only"
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
    bot.start_queue
    client.reply msg, "started playing your music :)"
  end
end