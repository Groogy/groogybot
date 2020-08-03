class Playlist
  @songs = [] of Song

  delegate size, find, each, :[], to: @songs

  def initialize()
  end

  def initialize(io : IO)
    @songs = Array(Song).from_yaml io
  end
end