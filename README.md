# Tremolo

InfluxDB UDP Tracker built on Celluloid::IO

## Installation

Add this line to your application's Gemfile:

    gem 'tremolo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tremolo

## Is it any good?

It's getting there, but some of the nuance of the method API and Celluloid's behavior are still being worked out. I'll let you know when it's settled down a bit more.

## Usage

```ruby
# Get an unsupervised tracker
tracker = Tremolo.tracker('0.0.0.0', 4444)

# options that can be set on the tracker:
# namespace, a string prefix for all series names on this tracker, joined with '.' (default="")
tracker = Tremolo.tracker('0.0.0.0', 4444, namespace: 'appname')

# tracker is a Celluloid Actor, it will not be GC'd like you would expect so I'd advise against doing it this way.

# Because we're using celluloid, we probably want to create a supervised tracker
Tremolo.supervised_tracker(:tracker, '0.0.0.0', 4444, namespace: 'appname')

# whenever you want to use this supervised tracker, you can always ask Celluloid
tracker = Celluloid::Actor[:tracker]

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

**Note** The default precision is `ms` it appears. So far there is no way to configure `time_precision` when using UDP. More info here: http://influxdb.com/docs/v0.7/api/reading_and_writing_data.html#time-precision-on-written-data

**Note** Be careful passing data to `write_point` that includes the keys `time` or `sequence_number`, they have special meaning to InfluxDB: http://influxdb.com/docs/v0.7/api/reading_and_writing_data.html#specifying-time-and-sequence-number-on-writes
