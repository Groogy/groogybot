class RequestSongCommand < Command
  def initialize
    super "!request", /^!request *(.*[^ ]) *$/, "subscribers can request songs using this command"
  end

  def has_permission?(msg)
    usr = User.new msg
    usr.elevated_status?
  end

  def execute(bot, client, msg, match)
    response = Response.new msg, client, 1, match
    return if response.handle_error

    if queue = bot.queue
      request = response.args[0]
      song = queue.add_request request
      if song
        response.reply "request for #{song.name} successfully added"
      else
        response.reply "couldn't find any song matching #{request}"
      end
    else
      response.reply "song requests are currently not enabled"
    end
  end
end