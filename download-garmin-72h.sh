#! /bin/sh

GPSBABEL=/usr/bin/gpsbabel
PORT=/dev/ttyACM0
DEVICE_TYPE=HOLUX245

echo Identifying device...
# How can we do this? It might not be possible
# The USB device does not have a serial number
# There does not seem to be any serial number (etc) in the garmin protocol data
# This the my device serial number, from
#    Main menu > System Info
ADDR=3821055173
DEVICE_ID=garmin-72h-$ADDR

echo Downloading tracks from $DEVICE_ID...

FPREFIX=$DEVICE_ID
R=$($GPSBABEL -t -i garmin -f usb: -o gpx -F $FPREFIX.gpx)
echo Downloading from $DEVICE_ID...done

