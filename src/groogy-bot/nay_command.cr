class NayCommand < Command
  def initialize
    super "!nay", /^!nay *$/, "register your vote as no for the current vote"
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
    response = Response.new msg, client
    return if response.handle_error

    if vote = bot.current_vote
      usr = User.new msg
      vote.register usr, false
    end
  end
end
