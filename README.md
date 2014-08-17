# Tremolo

InfluxDB UDP Tracker built on Celluloid::IO

## Installation

Add this line to your application's Gemfile:

    gem 'tremolo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tremolo

## Usage

```ruby
# Get a tracker
tracker = Tremolo.tracker('0.0.0.0', 4444)

# options that can be set on the tracker:
# namespace, a string prefix for all series names on this tracker, joined with '.' (default="")

tracker = Tremolo.tracker('0.0.0.0', 4444, namespace: 'appname')

# Write a point to 'series-name' series
tracker.write_point('series-name', {:value => 121, :otherdata => 998142})

# Create a series for repeated tracking
series = tracker.series('series-name')

# Write multiple points to the series with this name
series.write_point({:value => 18, :otherdata => 1986})
series.write_point({:value => 82, :otherdata => 1984})
series.write_point({:value => 11, :otherdata => 1984})

# track a value of 1 to a series
tracker.increment('count.series-name')
series = tracker.series('count.series-name')
series.increment

# track a value of -1 to a series
tracker.decrement('count.series-name')
series = tracker.series('count.series-name')
series.increment

# send some timing data
tracker.timing('timing.series-name', 48) # integer for ms
series = tracker.series('timing.series-name')
series.timing(210)

# returns the result of the block, and tracks the timing into series-name
value = tracker.time('timing.series-name') { Net::HTTP.get(URI('http://google.com')) }
series = tracker.series('timing.series-name')
value = series.time { Net::HTTP.get(URI('http://google.com')) }
```

## Databases, Namespace and Series names

Since version 0.7.1 of InfluxDB, multiple databases can be configured for different UDP ports. All
tracking in Tremolo is done by way of UDP.

So, port 4444 from the above goes to one database as configured, and port 8191 could go to a second DB.

This somewhat negates the need for the `namespace` option to be set for a `tracker` since each application
could be configured to go to its own InfluxDB database.

**Note** If disconnected, the tracker will silently fail to send stats to InfluxDB. These stats will be lost.
It will try to send each time, though. so when the server comes back up stats will begin sending again.

Some thought should be given to the design and structure of the namespace and series name. I like to have pattern like:

* use 'count.series-names' for any individual values, such as `increment` and `decrement`
* use 'timing.series-names' for any value tracked as milliseconds

## Contributing

1. Fork it ( https://github.com/[my-github-username]/tremolo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
