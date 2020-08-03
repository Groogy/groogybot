require "crirc"
require "yaml"
require "./groogy-bot/command.cr"
require "./groogy-bot/*"

CustomCommand.load
VoteGame.load

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
bot << AddGameCommand.new
bot << RemoveGameCommand.new
bot << StartGameCommand.new
bot << StopGameCommand.new
bot << AddVoteSlotCommand.new
bot << RemoveVoteSlotCommand.new
bot << ClaimVoteSlotCommand.new
bot << VotersCommand.new
bot << StartVoteCommand.new
bot << YayCommand.new
bot << NayCommand.new
bot << FilibusterCommand.new
bot << VoteStatusCommand.new
bot << AvailableVotersCommand.new

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
