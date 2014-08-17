require 'spec_helper'

describe Tremolo::Tracker do
  let(:socket) {stub(:connect => true, :send => true)}
  let(:tracker) {Tremolo.tracker('0.0.0.0', 4444)}

  before(:each) do
    Celluloid::IO::UDPSocket.stubs(:new).returns(socket)
  end

  it 'sends point data formatted for InfluxDB' do
    tracker.write_point('accounts.created', {value: 111, associated_id: 81102})

    json = '[{"name":"accounts.created","columns":["associated_id","value"],"points":[[81102,111]]}]'

    expect(socket).to have_received(:send).with(json, 0)
  end

  it 'sends single point with value 1' do
    tracker.increment('accounts.created')

    json = '[{"name":"accounts.created","columns":["value"],"points":[[1]]}]'

    expect(socket).to have_received(:send).with(json, 0)
  end

  it 'sends single point with value -1' do
    tracker.decrement('accounts.created')

    json = '[{"name":"accounts.created","columns":["value"],"points":[[-1]]}]'

    expect(socket).to have_received(:send).with(json, 0)
  end

  it 'tracks timing value for ms' do
    tracker.timing('timing.accounts.created', 89)

    json = '[{"name":"timing.accounts.created","columns":["value"],"points":[[89]]}]'

    expect(socket).to have_received(:send).with(json, 0)
  end

  it 'tracks block timing value for ms' do
    # PREVENT Timers in Celluloid from calling Time.now all the time
    Timers.any_instance.stubs(:wait_interval).returns(nil)

    start_at = Time.now
    end_at = start_at + 1.0135 # 1013.5 ms, rounds to 1014

    Time.stubs(:now).returns(start_at, end_at)

    returned = tracker.time('timing.accounts.created') do
      'returning a thing'
    end

    json = '[{"name":"timing.accounts.created","columns":["value"],"points":[[1014]]}]'

    expect(returned).to eq('returning a thing')
    expect(socket).to have_received(:send).with(json, 0)
  end

  context "with a namespace" do
    let(:tracker) {Tremolo.tracker('0.0.0.0', 4444, namespace: 'alf')}

    it 'tracks timing value for ms' do
      tracker.timing('timing.accounts.created', 14)

      json = '[{"name":"alf.timing.accounts.created","columns":["value"],"points":[[14]]}]'

      expect(socket).to have_received(:send).with(json, 0)
    end
  end
end
