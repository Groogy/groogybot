class RemoveGameCommand < Command
  def initialize
    super "!remgame", /^!remgame *(.*[^ ]) *$/, "removes a voting game with given name"
  end

  def has_permission?(msg)
    usr = User.new msg
    usr.broadcaster? || usr.moderator?
  end

  def execute(bot, client, msg, match)
    response = Response.new msg, client, 1, match
    return if response.handle_error

    name = response.args[0]
    success = VoteGame.remove name
    if success
      VoteGame.write
      response.reply "successfully removed #{name}"
    else
      response.reply "couldn't find game named '#{name}'"
    end
  end
end