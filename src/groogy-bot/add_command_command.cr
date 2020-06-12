class AddCommandCommand < Command
  def initialize
    super "!addcom", /^!addcom *(!\S*[^ ]) *(.*) *$/, "adds a new custom command"
  end

  def has_permission?(msg)
    tags = msg.tags_list
    if tag = tags["badges"]?
      tag.includes?("broadcaster") || tag.includes?("moderator")
    else
      false
    end
  end

  def execute(bot, msg, match)
    if match && match.size == 3
      name = match[1]
      response = match[2]
      command = CustomCommand.new name, response
      command.apply(bot)
      CustomCommand.add command
      CustomCommand.write
      bot.reply msg, "successfully added command #{name}"
    else
      bot.reply msg, "failed to create custom command"
    end
  end
end