class RemoveCommandCommand < Command
  def initialize
    super "!remcom", /^!remcom *(!\S*[^ ]) *$/, "remove a custom command"
  end

  def has_permission?(msg)
    usr = User.new msg
    usr.broadcaster? || usr.moderator?
  end

  def execute(bot, client, msg, match)
    response = Response.new msg, client, 1, match
    return if response.handle_error
    
    name = response.args[0]
    client.docs.delete name
    CustomCommand.remove name
    CustomCommand.write
    client.reply msg, "successfully removed command #{name}"
  end
end