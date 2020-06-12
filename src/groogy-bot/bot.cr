class Bot
  @config : Configuration
  @commands = [] of Command

  def initialize(config_file)
    @config = File.open config_file do |file|
      Configuration.from_yaml file
    end

    @client = Crirc::Network::Client.new @config.nick, @config.server, @config.port, ssl: @config.use_ssl, pass: "oauth:#{@config.oauth_token}"
  end

  def <<(command)
    @commands << command
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
      loop do
        begin
          m = bot.gets
          puts "> #{m}"
          break if m.nil?
          spawn { bot.handle(m.as(String)) }
        rescue error
          puts error
          sleep 0.1
        end
      end
    end
    @client.close
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
      command.apply(bot)
    end
  end
end
