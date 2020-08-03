class Response
  @error : String?
  @args = [] of String

  def initialize(@msg : Crirc::Protocol::Message, @client : Crirc::Controller::Client, expected : Int? = nil, args : Regex::MatchData? = nil)
    parse_arguments expected, args
  end

  def parse_arguments(expected : Int, args)
    if args.nil?
      @error = "expected #{expected} arguments, could parse 0"
    elsif args.captures.size != expected
      @error = "expected #{expected} arguments, could parse #{args.size}"
    end

    if args
      args.captures.each do |argument|
        puts argument
        @args << argument if argument
      end
    end
  end

  def parse_arguments(expected : Nil, args)
    @error = nil
  end

  def handle_error
    if error = @error
      reply "#{@error}"
      true
    else
      false
    end
  end

  def args
    @args
  end

  def reply(m)
    @client.reply @msg, "/me #{m}"
  end
end
