#! /bin/sh

BT747=/opt/BT747/run_j2se-batch.sh
PORT=/dev/ttyACM0
DEVICE_TYPE=HOLUX245
OUTDIR=./tracks

echo Identifying device...
ADDR=$($BT747 -p $PORT --device=$DEVICE_TYPE --mac-address | sed -n -e 's/Bluetooth Mac Addr://p' | sed -e 's/:/./g')
DEVICE_ID=holux-1000c-$ADDR
echo Identifying device...$DEVICE_ID


echo Downloading tracks from $DEVICE_ID...
rm -f $DEVICE_ID.bin
mkdir -p $OUTDIR
FPREFIX=$OUTDIR/$DEVICE_ID
R=$($BT747 -p $PORT --device=$DEVICE_TYPE -a -f $FPREFIX --timesplit=60 --splittype=TRACK --outtype=GPX)
rm -f $DEVICE_ID.bin
echo Downloading from $DEVICE_ID...done


echo Archiving tracks...
bzr add $OUTDIR/* 2> /dev/null
bzr commit $OUTDIR -m "Added tracks from $DEVICE_ID" 2> /dev/null
bzr push :parent 2> /dev/null
echo Archiving tracks...done

