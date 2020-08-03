class Bot
  @config : Configuration
  @commands = [] of Command
  @playlist = Playlist.new
  @queue : SongQueue?
  @current_vote : Vote?

  property playlist
  getter config, queue, current_vote

  def initialize(config_file)
    @config = File.open config_file do |file|
      Configuration.from_yaml file
    end

    @client = Crirc::Network::Client.new @config.nick, @config.server, @config.port, ssl: @config.use_ssl, pass: "oauth:#{@config.oauth_token}"
  end

  def <<(command)
    @commands << command
  end

  def start_queue
    @queue = SongQueue.new playlist
  end

  def stop_queue
    @queue.try { |q| q.stop }
    @queue = nil
  end

  def create_vote(target, minutes, text, usr)
    time = Time.utc
    time += Time::Span.new minutes: minutes
    @current_vote = Vote.new target, time, text, usr
  end

  def has_current_vote?
    !@current_vote.nil?
  end

  def connect
    @client.connect
    @client.puts "CAP REQ :twitch.tv/membership"
    @client.puts "CAP REQ :twitch.tv/tags"
    @client.puts "CAP REQ :twitch.tv/commands"
  end

  def run
    @client.start do |bot|
      bind bot
      spawn { update bot }
      loop do
        begin
          receive_message bot
        rescue error
          puts error
          sleep 0.1
        end
      end
    end
    @client.close
  end

  private def receive_message(bot)
    m = bot.gets
    puts "> #{m}"
    return if m.nil?
    spawn { bot.handle(m.as(String)) }
  end

  private def update(bot)
    loop do 
      if queue = @queue
        queue.update
      end
      if vote = @current_vote
        now = Time.utc
        if now > vote.end_time
          vote.end bot
          @current_vote = nil
        end
      end
      sleep 0.1
    end
  end

  private def bind(bot)
    bot.on_ready do
      # Join the default chan when the bot is connected
      @config.channels.each do |channel|
        bot.join Crirc::Protocol::Chan.new("##{channel}")
      end
    end.on("PING") do |msg|
      # Server pong
      bot.pong(msg.message)
    end

    @commands.each do |command|
      command.apply(self, bot)
    end
  end
end
