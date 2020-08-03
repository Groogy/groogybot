class User
  @tags : Hash(String, String)
  @nick : String

  def initialize(msg)
    @tags = msg.tags_list
    @nick = msg.source.split('!')[0]
  end

  def nick
    @nick
  end

  def badges
    if tag = @tags["badges"]
      tag
    else
      ""
    end
  end

  def broadcaster?
    badges.includes? "broadcaster"
  end

  def moderator?
    badges.includes? "moderator"
  end

  def subscriber?
    badges.includes?("subscriber") || badges.includes?("founder")
  end

  def vip?
    badges.includes? "vip"
  end

  def elevated_status?
    broadcaster? || moderator? || subscriber? || vip?
  end
end