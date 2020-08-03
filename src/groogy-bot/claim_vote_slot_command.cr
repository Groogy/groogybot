class ClaimVoteSlotCommand < Command
  def initialize
    super "!claimslot", /^!claimslot *(.*[^ ]) *$/, "claims a voting slot for the user with the given name"
  end

  def has_permission?(msg)
    usr = User.new msg
    usr.elevated_status?
  end

  def execute(bot, client, msg, match)
    response = Response.new msg, client, 1, match
    return if response.handle_error

    if current =  VoteGame.current
      usr = User.new(msg)
      if current.voter? usr
        response.reply "you already have a slot #{usr.nick}"
        return
      end
      name = response.args[0]
      slot = current.slots.find { |s| s.name == name }
      if slot
        if slot.claimed?
          response.reply "slot #{slot.name} is already claimed by #{slot.user_nick}"
        else
          slot.claim User.new msg
          response.reply "slot #{slot.name} now claimed by #{slot.user_nick}"
          VoteGame.write
        end
      else
        response.reply "no slot with name '#{name}' found in game #{current.name}"
      end
    else
      response.reply "no current voting game running"
    end
  end
end