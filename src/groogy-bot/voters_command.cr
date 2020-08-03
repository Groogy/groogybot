class VotersCommand < Command
  def initialize
    super "!voters", /!voters */, "will list all voter slots for the current vote game"
  end

  def execute(bot, client, msg, match)
    response = Response.new msg, client

    if current =  VoteGame.current
      slots = current.slots.join(", ") { |s| "#{s.user_nick ? s.user_nick : "free"}(#{s.name})" }
      response.reply "current voting slots are #{slots}"
    else
      response.reply "no current voting game running"
    end
  end
end