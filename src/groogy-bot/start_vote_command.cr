class StartVoteCommand < Command
  def initialize
    super "!startvote", /^!startvote *([0-9]+) *(.*[^ ]) *$/, "will start a vote that lasts for a given amount of minutes."
  end

  def has_permission?(msg)
    if current = VoteGame.current
      usr = User.new msg
      current.voter? usr
    else
      false
    end
  end

  def execute(bot, client, msg, match)
    response = Response.new msg, client, 2, match
    return if response.handle_error

    if current =  VoteGame.current
      time = response.args[0].to_i64
      text = response.args[1]
      if time < 5
        response.reply "a vote can not be shorter than 5 minutes"
      elsif time > 20
        response.reply "a vote can not be longer than 20 minutes"
      elsif bot.has_current_vote?
        response.reply "a vote has already been called!"
      else
        usr = User.new msg
        vote = bot.create_vote Crirc::Protocol::Chan.new(msg.argument_list.first), time, text, usr
        response.reply "HEAR YE HEAR YE! A VOTE HAS BEEN CALLED BY #{usr.nick.capitalize}! The vote will expire in #{time} minutes! Vote using !yay or !nay"
        sleep 1
        response.reply vote.text
      end
    else
      response.reply "no current voting game running"
    end
  end
end