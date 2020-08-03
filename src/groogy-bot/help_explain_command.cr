class HelpExplainCommand < Command
  def initialize
    super "!help", /^!help *(.*[^ ]) *$/, ""
  end

  def execute(bot, client, msg, match)
    response = Response.new msg, client, 1, match
    return if response.handle_error

    doc = client.docs[response.args[0]]?
    doc.split("\n").each { |split| response.reply split } unless doc.nil?
  end
end
