class AddCommandCommand < Command
  def initialize
    super "!addcom", /^!addcom *(!\S*[^ ]) *(.*) *$/, "adds a new custom command"
  end

  def has_permission?(msg)
    usr = User.new msg
    usr.broadcaster? || usr.moderator?
  end

  def execute(bot, client, msg, match)
    response = Response.new msg, client, 2, match
    return if response.handle_error

    n = response.args[0]
    r = response.args[1]
    command = CustomCommand.new n, r
    command.apply bot, client
    CustomCommand.add command
    CustomCommand.write
    response.reply "successfully added command #{n}"
  end
end