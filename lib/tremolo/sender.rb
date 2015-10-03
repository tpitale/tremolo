module Tremolo
  class Sender
    include Celluloid::IO

    def initialize(host, port)
      @socket = UDPSocket.new
      @socket.connect(host, port) # client
    end

    def write_points(series_name, data)
      begin
        @socket.send(prepare(series_name, data), 0)
      rescue Errno::ECONNREFUSED
        nil
      end
    end

    private
    def prepare(series_name, data)
      DataPoint.new(series_name, data).lines
    end
  end
end
