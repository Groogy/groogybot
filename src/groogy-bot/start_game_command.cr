class StartGameCommand < Command
  def initialize
    super "!startgame", /^!startgame *(.*[^ ]) *$/, "will make game with given name the active voting game"
  end

  def has_permission?(msg)
    usr = User.new msg
    usr.broadcaster? || usr.moderator?
  end

  def execute(bot, client, msg, match)
    response = Response.new msg, client, 1, match
    return if response.handle_error

    name = response.args[0]
    game = VoteGame.find name
    if game
      VoteGame.make_current game
      response.reply "loaded game #{name} with the following voters: #{game.slots.join(", ") { |s| s.display_name }}"
    else
      response.reply "couldn't find game with name '#{name}'"
    end
  end
end