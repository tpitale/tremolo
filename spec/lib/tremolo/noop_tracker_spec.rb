require 'spec_helper'

describe Tremolo::NoopTracker do
  let(:socket) {stub(:connect => true, :send => true)}
  let(:tracker) {Tremolo.tracker(nil, nil)}

  before(:each) do
    Celluloid::IO::UDPSocket.stubs(:new).returns(socket)
  end

  it 'does not send point data formatted for InfluxDB' do
    tracker.write_point('accounts.created', {value: 111, associated_id: 81102})

    expect(socket).to have_received(:send).never
  end

  it 'does not send single point with value 1' do
    tracker.increment('accounts.created')

    expect(socket).to have_received(:send).never
  end

  it 'does not send single point with value -1' do
    tracker.decrement('accounts.created')

    expect(socket).to have_received(:send).never
  end

  it 'does not track timing value' do
    tracker.timing('timing.accounts.created', 89)

    expect(socket).to have_received(:send).never
  end

  it 'does not track block timing' do
    returned = tracker.time('timing.accounts.created') do
      'returning a thing'
    end

    expect(returned).to eq('returning a thing')
    expect(socket).to have_received(:send).never
  end
end
