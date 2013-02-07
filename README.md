gpx-calculator
==============

After you have finished a race, you can view your GPS track using
any one of a number of online or installed applications. However,
I have not found one that will add index markers to the track
at regular time or distance intervals, and display the time
and speed (and other properties) at those places.

This set of scripts will take a GPX file containing a track
and generate GPX files containing waypoints.

* One file contains waypoints at regular time intervals

* One file contains waypoints at regular distance intervals


Each waypoint has a name and description that includes some of:

* position (lat/long)
* time
* duration from start of track
* speed
* altitude
* wind speed and direction
* tide


Usage
-----

    ./create-track-markers.lua <gpx-file>  <distance>  <time>

Input
-----
* A GPX file containing one or more GPS tracks, with the GPX <trk> tag

* A parameter specifying the distance between points

* A parameter specifying the time between points


Output
------
Two GPX files containing

* waypoints calculated at regular time intervals

* waypoints calculated at regular distance intervals


Each calculated waypoint has the following data calculated from
the track data:

* latitude and longitude

* time in UTC
 
* time in seconds from the start of the track

* distance from the start of the track

* speed



Dependencies
------------

* XML parsing and generation
  * Penlight

* Date parsing
  * http://wiki.interfaceware.com/302.html
  
* Geographical calculations
  * http://www.movable-type.co.uk/scripts/latlong.html

* Unit test
  * luaunit (http://phil.freehackers.org/programs/luaunit/)


License
-------

Copyright (C) 2012 Stephen Irons

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

