require 'spec_helper'

describe Tremolo::Tracker do
  let(:socket) {stub(:connect => true, :send => true)}
  let(:tracker) {Tremolo.tracker('0.0.0.0', 4444)}
  let(:series) {tracker.series('accounts.created')}

  before(:each) do
    Celluloid::IO::UDPSocket.stubs(:new).returns(socket)
  end

  it 'sends point data formatted for InfluxDB' do
    series.write_point({value: 111, associated_id: 81102})

    json = '[{"name":"accounts.created","columns":["associated_id","value"],"points":[[81102,111]]}]'

    expect(socket).to have_received(:send).with(json, 0)
  end

  it 'sends single point with value 1' do
    series.increment

    json = '[{"name":"accounts.created","columns":["value"],"points":[[1]]}]'

    expect(socket).to have_received(:send).with(json, 0)
  end

  it 'sends single point with value -1' do
    series.decrement

    json = '[{"name":"accounts.created","columns":["value"],"points":[[-1]]}]'

    expect(socket).to have_received(:send).with(json, 0)
  end

  it 'tracks timing value for ms' do
    series.timing(89)

    json = '[{"name":"accounts.created","columns":["value"],"points":[[89]]}]'

    expect(socket).to have_received(:send).with(json, 0)
  end

  it 'tracks block timing value for ms' do
    # PREVENT Timers in Celluloid from calling Time.now all the time
    Timers.any_instance.stubs(:wait_interval).returns(nil)

    start_at = Time.now
    end_at = start_at + 1.05 # 1013.5 ms, rounds to 1014

    Time.stubs(:now).returns(start_at, end_at)

    returned = series.time do
      'returning another thing'
    end

    json = '[{"name":"accounts.created","columns":["value"],"points":[[1050]]}]'

    expect(returned).to eq('returning another thing')
    expect(socket).to have_received(:send).with(json, 0)
  end
end
