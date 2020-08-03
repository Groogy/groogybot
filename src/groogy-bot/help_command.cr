class HelpCommand < Command
  def initialize
    super "!help", /^!help *$/, "`!help` to list the modules\n`!help cmd` to advanced description of the cmd"
  end

  def execute(bot, client, msg, match)
    client.reply msg, client.docs.keys.join(", ")
  end
end