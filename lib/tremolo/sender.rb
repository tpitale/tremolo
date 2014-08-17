module Tremolo
  class Sender
    # include Celluloid::Logger
    include Celluloid::IO

    def initialize(host, port)
      @socket = UDPSocket.new
      @socket.connect(host, port) # client
    end

    def write_points(series_name, data)
      begin
        @socket.send(prepare(series_name, data), 0)
      rescue Errno::ECONNREFUSED => e
        # debug "Connection refused. Ignoring."
        nil
      end
    end

    private
    def prepare(series_name, data)
      JSON.generate(DataPoint.from_hash(series_name, data).as_json)
    end
  end
end
