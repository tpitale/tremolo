require 'spec_helper'

describe Tremolo::Tracker do
  let(:socket) {stub(:connect => true, :send => true)}
  let(:tracker) {
    Tremolo.supervised_tracker(:tracker, '0.0.0.0', 4444)
  }

  before(:each) do
    Celluloid::IO::UDPSocket.stubs(:new).returns(socket)
  end

  it 'sends point data formatted for InfluxDB', :celluloid => true do
    tracker.write_point('accounts.created', {value: 111, associated_id: 81102})

    line = 'accounts.created value=111,associated_id=81102'

    sleep 0.1
    expect(socket).to have_received(:send).with(line, 0)
  end

  it 'sends single point with value 1', :celluloid => true do
    tracker.increment('accounts.created')

    line = 'accounts.created value=1'

    sleep 0.1
    expect(socket).to have_received(:send).with(line, 0)
  end

  it 'sends single point with value -1', :celluloid => true do
    tracker.decrement('accounts.created')

    line = 'accounts.created value=-1'

    sleep 0.1
    expect(socket).to have_received(:send).with(line, 0)
  end

  it 'tracks timing value for ms', :celluloid => true do
    tracker.timing('timing.accounts.created', 89)

    line = 'timing.accounts.created value=89'

    sleep 0.1
    expect(socket).to have_received(:send).with(line, 0)
  end

  it 'tracks block timing value for ms', :celluloid => true do
    # PREVENT Timers in Celluloid from calling Time.now all the time
    Timers.stubs(:wait_interval).returns(nil)

    start_at = Time.now
    end_at = start_at + 1.0135 # 1013.5 ms, rounds to 1014

    Time.stubs(:now).returns(start_at, end_at)

    returned = tracker.time('timing.accounts.created') do
      'returning a thing'
    end

    line = 'timing.accounts.created value=1014'

    sleep 0.1
    expect(returned).to eq('returning a thing')
    expect(socket).to have_received(:send).with(line, 0)
  end

  context "with a namespace" do
    let(:tracker) {Tremolo.tracker('0.0.0.0', 4444, namespace: 'alf')}

    it 'tracks timing value for ms', :celluloid => true do
      tracker.timing('timing.accounts.created', 14)

      line = 'alf.timing.accounts.created value=14'

      sleep 0.1
      expect(socket).to have_received(:send).with(line, 0)
    end
  end
end
