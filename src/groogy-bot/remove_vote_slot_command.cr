class RemoveVoteSlotCommand < Command
  def initialize
    super "!remslot", /^!remslot *(.*[^ ]) *$/, "removes a slot for the current voting game with the given name"
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
      current.remove_slot name
      VoteGame.write
      response.reply "removed voting slot #{name} from #{current.name}"
    else
      response.reply "no current voting game running"
    end
  end
end