class HelpExplainCommand < Command
  def initialize
    super "!help", /^!help *(.*[^ ]) *$/, ""
  end

  def execute(bot, msg, match)
    doc = bot.docs[match.as(Regex::MatchData)[1]]?
    doc.split("\n").each { |split| bot.reply msg, split } unless doc.nil?
  end
end