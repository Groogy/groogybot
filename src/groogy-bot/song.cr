class Song
  include YAML::Serializable

  @[YAML::Field(key: "name")]
  getter name : String

  @[YAML::Field(key: "path")]
  getter path : String

  def initialize(@name, @path)
  end

  def play
    puts "Playing #{name}"
    Player.open @path
    Player.play
  end
end
