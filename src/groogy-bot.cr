require "crirc"
require "yaml"
require "./groogy-bot/command.cr"
require "./groogy-bot/*"

CustomCommand.load

bot = Bot.new "config.yml"

Player.player = bot.config.music_player

bot << PingCommand.new 
bot << HelpCommand.new
bot << HelpExplainCommand.new
bot << SongCommand.new
bot << StartMusicCommand.new
bot << StopMusicCommand.new
bot << RequestSongCommand.new
bot << AddCommandCommand.new
bot << RemoveCommandCommand.new

CustomCommand.each do |c|
  bot << c
end

if File.exists? "playlist.yml"
  File.open "playlist.yml" do |file|
    bot.playlist = Playlist.new(file)
  end
end

bot.connect
bot.run
