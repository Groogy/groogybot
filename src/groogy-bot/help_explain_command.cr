class HelpExplainCommand < Command
  def initialize
    super "!help", /^!help *(.*[^ ]) *$/, ""
  end

  def execute(bot, client, msg, match)
    doc = client.docs[match.as(Regex::MatchData)[1]]?
    doc.split("\n").each { |split| client.reply msg, split } unless doc.nil?
  end
end