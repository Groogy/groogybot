class VoteStatusCommand < Command
  def initialize
    super "!votestatus", /^!votestatus *$/, "report on the current votes status, like time and registered votes"
  end

  def has_permission?(msg)
    usr = User.new msg
    return true if usr.broadcaster? || usr.moderator?
    if current = VoteGame.current
      current.voter? usr
    else
      false
    end
  end

  def execute(bot, client, msg, match)
    response = Response.new msg, client
    return if response.handle_error

    if current = VoteGame.current
      if vote = bot.current_vote
        response.reply vote.text
        sleep 1
        response.reply "there is #{vote.time_left} minutes left on this vote. It has been filibustered #{vote.filibuster_counter} times.\n"
        
        yay = vote.votes_for
        nay = vote.votes_against
        abstained = current.slots.select do |s|
          !yay.includes?(s.user_nick) && !nay.includes?(s.user_nick)
        end

        sleep 1
        votes_text = "There are #{yay.size} votes for, #{nay.size} votes against and #{abstained.size} abstainees. "
        unless abstained.empty?
          votes_text += "Currently missing votes from: #{abstained.join(", ") { |s| s.display_name }}"
        end
        response.reply votes_text
      else
        response.reply "there is no vote currently ongoing"
      end
    else
      response.reply "there is no vote currently ongoing"
    end
  end
end