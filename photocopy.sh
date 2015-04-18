#!/bin/bash

# input: a list of scanned jpg images
# output: a 'photocopied', merged, black and white printed output


i=0
PRINTER=brother
LOCALTHRESH=~/git/scripts/localthresh

for IMAGE in "$@"
do

  echo Image $IMAGE
  CURRENT=$IMAGE
  if [ $((i%2)) -eq 0 ]
  then
    EVEN=$CURRENT
    echo applying threshold to create even /tmp/thresh.$EVEN
    $LOCALTHRESH -n yes -m 3 -r 35 -b 20 $EVEN /tmp/thresh.$EVEN
    echo creating postscript even /tmp/$EVEN.ps
    convert /tmp/thresh.$EVEN /tmp/$EVEN.ps
  else
    ODD=$CURRENT
    echo applying threshold to create odd /tmp/thresh.$ODD
    $LOCALTHRESH -n yes -m 3 -r 35 -b 20 $ODD /tmp/thresh.$ODD
    echo creating postscript odd /tmp/$ODD.ps
    convert /tmp/thresh.$ODD /tmp/$ODD.ps
    echo merging /tmp/$EVEN.ps and /tmp/$ODD.ps to /tmp/merge.$i.ps
    psmerge -o/tmp/merge.$i.ps /tmp/$EVEN.ps /tmp/$ODD.ps
    unset EVEN
    echo printing $TMPFILE
    lp -d $PRINTER /tmp/merge.$i.ps
  fi
  i=$((i+1))

done

if [ ! -z $EVEN ]
then
  echo printing final even page
  lp -d $PRINTER /tmp/$EVEN.ps
fi
