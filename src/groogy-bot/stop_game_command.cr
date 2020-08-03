class StopGameCommand < Command
  def initialize
    super "!stop", /!stop */, "stops the current running game"
  end

  def has_permission?(msg)
    usr = User.new msg
    usr.broadcaster? || usr.moderator?
    
  end

  def execute(bot, client, msg, match)
    response = Response.new msg, client
    VoteGame.reset_current
    response.reply "successfully stopped the game"
  end
end