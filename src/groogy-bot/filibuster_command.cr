class FilibusterCommand < Command
  def initialize
    super "", /^ *(.*[^ ]) *$/, ""
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
    usr = User.new msg
    tags = msg.tags_list
    id = tags["custom-reward-id"]?
    if id == "6b3c667c-651c-4143-bd0e-d63b87e541c0"
      if vote = bot.current_vote
        vote.filibuster
        response.reply "the current vote has been filibustered and there is now #{vote.time_left} minutes left!"
      else
        response.reply "hahaha #{usr.nick} just wasted 2 000 political influence!"
      end
    end
  end
end