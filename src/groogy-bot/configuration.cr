class Configuration
  include YAML::Serializable

  @[YAML::Field(key: "server")]
  property server : String

  @[YAML::Field(key: "port")]
  property port : Int32

  @[YAML::Field(key: "ssl")]
  property use_ssl : Bool

  @[YAML::Field(key: "nick")]
  property nick : String

  @[YAML::Field(key: "oauth")]
  property oauth_token : String

  @[YAML::Field(key: "channels")]
  property channels : Array(String)

  @[YAML::Field(key: "music_player")]
  property music_player : String
end
