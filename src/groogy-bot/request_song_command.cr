class RequestSongCommand < Command
  def initialize
    super "!request", /^!request *(.*[^ ]) *$/, "subscribers can request songs using this command"
  end

  def has_permission?(msg)
    tags = msg.tags_list
    if tag = tags["badges"]?
      tag.includes?("broadcaster") || tag.includes?("moderator") || tag.includes?("vip") || tag.includes?("subscribers")
    else
      false
    end
  end

  def execute(bot, client, msg, match)
    if !match || match.size != 2
      client.reply msg, "invalid arguments"
      return
    end

    if queue = bot.queue
      request = match.as(Regex::MatchData)[1]
      song = queue.add_request request
      if song
        client.reply msg, "request for #{song.name} successfully added"
      else
        client.reply msg, "couldn't find any song matching #{request}"
      end
    else
      client.reply msg, "song requests are currently not enabled"
    end
  end
end