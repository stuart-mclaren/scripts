#!/bin/bash


#input: a set of standalone pdf files
#output: a print out of the pdf files, with no wasted paper, ie merged.

i=0
LOCALTHRESH=~/git/scripts/localthresh

for IMAGE in "$@"
do

  echo Image $IMAGE
  CURRENT=$IMAGE
  if [ $((i%2)) -eq 0 ]
  then
    EVEN=$CURRENT
    echo creating postscript even /tmp/$EVEN.ps
    pdftops $EVEN /tmp/$EVEN.ps
  else
    ODD=$CURRENT
    echo creating postscript odd /tmp/$ODD.ps
    pdftops $ODD /tmp/$ODD.ps
    echo merging /tmp/$EVEN.ps and /tmp/$ODD.ps to /tmp/merge.$i.ps
    psmerge -o/tmp/merge.$i.ps /tmp/$EVEN.ps /tmp/$ODD.ps
    unset EVEN
    echo printing $TMPFILE
    lp  /tmp/merge.$i.ps
  fi
  i=$((i+1))

done

if [ ! -z $EVEN ]
then
  echo printing final even page
  lp  /tmp/$EVEN.ps
fi
