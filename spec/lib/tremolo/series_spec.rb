require 'spec_helper'

describe Tremolo::Series do
  let(:socket) {stub(:connect => true, :send => true)}
  let(:tracker) {
    Tremolo.supervised_tracker(:tracker, '0.0.0.0', 4444)
  }
  let(:series) {tracker.series('accounts.created')}

  before(:each) do
    Celluloid::IO::UDPSocket.stubs(:new).returns(socket)
  end

  it 'sends point data formatted for InfluxDB', :celluloid => true do
    series.write_point({value: 111, associated_id: 81102})

    line = 'accounts.created value=111,associated_id=81102'

    sleep 0.1
    expect(socket).to have_received(:send).with(line, 0)
  end

  it 'sends single point with value 1', :celluloid => true do
    series.increment

    line = 'accounts.created value=1'

    sleep 0.1
    expect(socket).to have_received(:send).with(line, 0)
  end

  it 'sends single point with value -1', :celluloid => true do
    series.decrement

    line = 'accounts.created value=-1'

    sleep 0.1
    expect(socket).to have_received(:send).with(line, 0)
  end

  it 'tracks timing value for ms', :celluloid => true do
    series.timing(89)

    line = 'accounts.created value=89'

    sleep 0.1
    expect(socket).to have_received(:send).with(line, 0)
  end

  it 'tracks block timing value for ms', :celluloid => true do
    # PREVENT Timers in Celluloid from calling Time.now all the time
    Timers.stubs(:wait_interval).returns(nil)

    start_at = Time.now
    end_at = start_at + 1.05 # 1013.5 ms, rounds to 1014

    Time.stubs(:now).returns(start_at, end_at)

    returned = series.time do
      'returning another thing'
    end

    line = 'accounts.created value=1050'

    sleep 0.1
    expect(returned).to eq('returning another thing')
    expect(socket).to have_received(:send).with(line, 0)
  end
end
