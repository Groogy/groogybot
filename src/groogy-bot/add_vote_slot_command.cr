class AddVoteSlotCommand < Command
  def initialize
    super "!addslot", /^!addslot *(.*[^ ]) *$/, "creates a new slot for the current voting game with the given name"
  end

  def has_permission?(msg)
    usr = User.new msg
    usr.broadcaster? || usr.moderator?
  end

  def execute(bot, client, msg, match)
    response = Response.new msg, client, 1, match
    return if response.handle_error

    if current =  VoteGame.current
      name = response.args[0]
      current.add_slot VoteSlot.new name
      VoteGame.write
      response.reply "added voting slot #{name} for #{current.name}"
    else
      response.reply "no current voting game running"
    end
  end
end