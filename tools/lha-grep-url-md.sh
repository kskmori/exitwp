#!/bin/sh
#grep -ohER "\(http[^)]*\)" $*
#grep -ohER "\]\([^)]+\)" $* | sed -e 's/^.*(\(.*\)).*$/\1/p'
grep -ohER "\]\([^)]+\)" $* 

