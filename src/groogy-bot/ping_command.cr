class PingCommand < Command
  def initialize
    super "!ping", /!ping */, "the bot respond by `pong nick`"
  end

  def execute(bot, client, msg, match)
    chan = msg.arguments if msg.arguments
    client.reply msg, "pong #{extract_nick msg.source}" if chan
  end

  private def extract_nick(address : String)
    address.split('!')[0]
  end
end