module Tremolo
  class Sender
    include Celluloid::IO

    def initialize(host, port)
      @socket = UDPSocket.new
      @socket.connect(host, port) # client
    end

    def write_points(series_name, values, tags = {})
      begin
        @socket.send(prepare(series_name, values, tags), 0)
      rescue Errno::ECONNREFUSED
        nil
      end
    end

    private
    def prepare(series_name, values, tags = {})
      DataPoint.new(series_name, {:values => values, :tags => tags}).lines
    end
  end
end
