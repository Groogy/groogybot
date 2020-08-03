class PingCommand < Command
  def initialize
    super "!ping", /!ping */, "the bot respond by `pong nick`"
  end

  def execute(bot, client, msg, match)
    response = Response.new msg, client
    usr = User.new msg
    response.reply "pong #{usr.nick}"
  end
end