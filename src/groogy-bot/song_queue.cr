class SongQueue
  @playlist : Playlist
  @requests = [] of Song

  def initialize(@playlist)
  end

  def update
    unless is_playing?
      if @requests.empty?
        play_random
      else
        play_request
      end
      sleep 0.1
    end
  end

  def add_request(search) : Song?
    search = search.downcase
    song = @playlist.find do |song|
      song.name.downcase.includes? search
    end
    @requests << song if song
    song
  end

  def play_random
    index = Random.rand @playlist.size
    @playlist[index].play
  end

  def play_request
    song = @requests.shift
    song.play
  end

  def stop
    Player.stop
  end

  def is_playing? : Bool
    status = Player.status
    status == "Playing"
  end
end