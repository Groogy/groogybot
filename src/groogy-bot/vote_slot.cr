class VoteSlot
  include YAML::Serializable

  @[YAML::Field(key: "name")]
  getter name : String

  @[YAML::Field(key: "nick")]
  getter user_nick : String?

  def initialize(@name : String)
  end

  def claim(user)
    @user_nick = user.nick
  end

  def claimed?
    !@user_nick.nil?
  end

  def claimed_by?(user : User)
    user.nick == @user_nick
  end

  def display_name
    user_nick ? user_nick : "(#{name})"
  end
end