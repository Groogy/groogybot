class HelpCommand < Command
  def initialize
    super "!help", /^!help *$/, "`!help` to list the modules\n`!help cmd` to advanced description of the cmd"
  end

  def execute(bot, msg, match)
    bot.reply msg, bot.docs.keys.join(", ")
  end
end