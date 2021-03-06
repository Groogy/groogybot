abstract class Command
  getter command : String
  getter pattern : Regex
  getter documentation : String

  def initialize(@command, @pattern, @documentation)
  end

  def has_permission?(msg)
    true
  end

  def apply(bot, client)
    client.on("PRIVMSG", message: pattern, doc: {command, documentation} ) do |msg, match|
      execute bot, client, msg, match if has_permission? msg
    end
  end

  abstract def execute(bot, client, msg, match)
end