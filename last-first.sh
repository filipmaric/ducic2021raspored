#!/bin/bash
tail -1 $1 > $1.last
head -n -1 $1 > $1.butlast
cat $1.last $1.butlast
rm $1.last
rm $1.butlast
