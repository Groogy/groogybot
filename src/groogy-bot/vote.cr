class Vote
  getter end_time : Time
  getter text : String
  getter user : User
  getter filibuster_counter = 0

  @votes = {} of String => Bool

  def initialize(@target : Crirc::Protocol::Target, @end_time, @text, @user)
  end

  def register(usr : User, vote : Bool)
    @votes[usr.nick] = vote
  end

  def filibuster
    @end_time += Time::Span.new minutes: 5
    @filibuster_counter += 1
  end

  def time_left
    now = Time.utc
    (@end_time - now).minutes
  end

  def votes_for
    @votes.select do |key, vote|
      key if vote
    end.keys
  end

  def votes_against
    @votes.select do |key, vote|
      key unless vote
    end.keys
  end

  def end(bot)
    yay = votes_for
    nay = votes_against
    abstained = [] of VoteSlot
    if current = VoteGame.current
      abstained = current.slots.select do |s|
        !yay.includes?(s.user_nick) && !nay.includes?(s.user_nick)
      end
    end

    bot.privmsg @target, "end of voting session! There were #{yay.size} votes for, #{nay.size} votes against and #{abstained.size} abstanees."
    sleep 1
    bot.privmsg @target, "For: #{yay.join(",")} | Against: #{nay.join(",")} | Abstain: #{abstained.join(",") { |s| s.display_name }}"
  end
end