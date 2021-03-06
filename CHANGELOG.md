## Tremolo 0.3.0 ##

*   Switch to require celluloid/current to not trigger deprecation warning

    *Tony Pitale*

## Tremolo 0.2.2 ##

*   Fix tremolo on ruby 2.1 series

    *Tony Pitale*

## Tremolo 0.2.1 ##

*   Add `Tremolo.fetch` in place of using Celluloid

    *Tony Pitale*

## Tremolo 0.2.0 ##

*   Adds tags to `Tracker` and `Series`

    *Tony Pitale*

## Tremolo 0.1.0 ##

*   Wireline compatibility with Influxdb 0.9 series
*   Update celluloid to 0.17.2+

    *Tony Pitale*

## Tremolo 0.0.4 ##

*   Make Tremolo::Tracker a Celluloid actor so that it can be supervised if desired
*   Trap a dying Sender in Tracker and set to nil to let it reload
*   Create Sender on the fly in the Tracker using `new_link`
*   Add Tremolo.supervised_tracker

    *Tony Pitale*

## Tremolo 0.0.3 ##

*   Bump celluloid-io requirement to support `UDPSocket.connect`

    *Tony Pitale*

## Tremolo 0.0.2 ##

*   Track stats with an optional :namespace

    *Tony Pitale*

## Tremolo 0.0.1 ##

*   Initial implementation
*   Track stats with: increment, decrement, write_point(s), timing, and time

    *Tony Pitale*
