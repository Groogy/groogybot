class RemoveCommandCommand < Command
  def initialize
    super "!remcom", /^!remcom *(!\S*[^ ]) *$/, "remove a custom command"
  end

  def has_permission?(msg)
    tags = msg.tags_list
    if tag = tags["badges"]?
      tag.includes?("broadcaster") || tag.includes?("moderator")
    else
      false
    end
  end

  def execute(bot, client, msg, match)
    if match && match.size == 2
      name = match[1]
      client.docs.delete name
      CustomCommand.remove name
      CustomCommand.write
      client.reply msg, "successfully removed command #{name}"
    else
      client.reply msg, "failed to remove custom command"
    end
  end
end