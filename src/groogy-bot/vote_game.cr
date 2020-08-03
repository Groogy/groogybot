class VoteGame
  include YAML::Serializable

  @@games = [] of VoteGame
  @@current : VoteGame?

  def self.add(game : VoteGame)
    @@games << game
  end

  def self.remove(name) : Bool
    success = false
    @@games.each do |g| 
      if g.name == name
        @@games.delete g
        success = true
        break
      end
    end
    if current = @@current
      current = nil if current.name == name
    end
    success
  end

  def self.each
    @@games.each do |c|
      yield c
    end
  end

  def self.find(name)
    @@games.find { |g| g.name == name }
  end

  def self.make_current(game)
    @@current = game
  end

  def self.reset_current
    @@current = nil
  end

  def self.current
    @@current
  end

  def self.load
    @@games = File.open "vote_games.yml" do |file|
      Array(VoteGame).from_yaml file
    end
  end

  def self.write
    File.open "vote_games.yml", "w" do |file|
      @@games.to_yaml file
    end
  end


  @[YAML::Field(key: "name")]
  getter name : String

  @[YAML::Field(key: "slots")]
  getter slots = [] of VoteSlot


  def initialize(@name)
  end

  def add_slot(slot : VoteSlot)
    @slots << slot
  end

  def remove_slot(name : String)
    @slots.delete @slots.find { |s| s.name == name }
  end

  def voter?(usr : User)
    @slots.find { |s| s.user_nick == usr.nick } != nil
  end
end
