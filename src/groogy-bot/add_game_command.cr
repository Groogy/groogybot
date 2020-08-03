class AddGameCommand < Command
  def initialize
    super "!addgame", /^!addgame *(.*[^ ]) *$/, "creates a new voting game with the given name"
  end

  def has_permission?(msg)
    usr = User.new msg
    usr.broadcaster? || usr.moderator?
  end

  def execute(bot, client, msg, match)
    response = Response.new msg, client, 1, match
    return if response.handle_error

    game = VoteGame.new response.args[0]
    VoteGame.add game
    VoteGame.write
    response.reply "successfully created #{game.name} sirgro1Plan"
  end
end