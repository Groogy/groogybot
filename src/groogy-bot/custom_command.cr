class CustomCommand < Command
  @@commands = [] of CustomCommand

  struct Data
    include YAML::Serializable

    @[YAML::Field(key: "command")]
    property command

    @[YAML::Field(key: "response")]
    property response

    def initialize(@command = "", @response = "")
    end
  end

  def self.add(command)
    @@commands << command
  end

  def self.remove(name)
    @@commands.each do |c| 
      if c.command == name
        @@commands.delete c
        c.delete
        break
      end
    end
  end

  def self.each
    @@commands.each do |c|
      yield c
    end
  end

  def self.load
    data = File.open "commands.yml" do |file|
      Array(Data).from_yaml file
    end
    @@commands = data.map { |d| CustomCommand.new d.command, d.response }
  end

  def self.write
    data = @@commands.map { |c| Data.new c.command, c.response }
    File.open "commands.yml", "w" do |file|
      data.to_yaml file
    end
  end

  getter response : String
  getter deleted = false

  def initialize(command, @response : String)
    super command, /^#{command} */, ""
  end

  def delete
    @deleted = true
  end

  def execute(bot, client, msg, match)
    client.reply msg, @response unless @deleted
  end
end