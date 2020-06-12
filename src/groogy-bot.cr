require "crirc"
require "yaml"
require "./groogy-bot/command.cr"
require "./groogy-bot/*"

CustomCommand.load

bot = Bot.new "config.yml"
bot << PingCommand.new 
bot << HelpCommand.new
bot << HelpExplainCommand.new
bot << SongCommand.new
bot << AddCommandCommand.new
bot << RemoveCommandCommand.new

CustomCommand.each do |c|
  bot << c
end

bot.connect
bot.run
