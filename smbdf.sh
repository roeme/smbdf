#!/bin/bash
#
# This lets you adjust df output for samba shares
# (i.e. for artificially limiting free space for a 
# particular share) in conjunction with "dfree command" in
# smb.conf

# Comes in very handy if you have your shares on a big
# fat disk, but don't want your users to errorneously assume
# they have plenty of space available (samba always reports
# the free space of the backing partition).


# To set the max total space, either set SBD_MAXSIZE/SBD_UNIT or:

# - call this script by a symlink with the name
# containing the max size you wish to have reported. the name
# is matched against this regex:
#
# \w*-\d{1,}[mgt] 
#
# where $1 is any name you want, $2 the desired max. size to be 
# reported and $3 the IEC unit of $2 (mebi-, gibi-, tebibyte).

# or
# - pass maxsize/unit in $2 in the same format as above

SBD_MAXSIZE=1
SBD_UNIT=t

# overwrite above if called appropiately
if [[ `basename "$0"` =~ ^[[:alnum:]]*-([[:digit:]]{1,})([mgt])$ ]]; then
  SBD_MAXSIZE=${BASH_REMATCH[1]}
  SBD_UNIT=${BASH_REMATCH[2]}

# elsewise, maybe a maxsize was passed?
elif [[ -n "${2:-}" ]]; then
  if [[ "$2" =~ ^([[:digit:]]{1,})([mgt])$ ]]; then
    SBD_MAXSIZE=${BASH_REMATCH[1]}
    SBD_UNIT=${BASH_REMATCH[2]}
  else
    echo "$0: Malformed max size spec" >&2
    exit 1
  fi
fi

# calculate max space 1K blocks
case $SBD_UNIT in
  m)
    max1k=$(( $SBD_MAXSIZE * ( 1024 ) ))
    ;;
  g)
    max1k=$(( $SBD_MAXSIZE * ( 1024 ** 2) ))
    ;;
  t)
    max1k=$(( $SBD_MAXSIZE * ( 1024 ** 3) ))
    ;;
  *)
    echo "$0: Illegal unit: $SBD_UNIT" >&2
    exit 1
esac

# get real free blocks
# this might take some time.
free1k=$(( $max1k - `du -s "$1" | cut -f 1` ))

# and we're done
echo $max1k $free1k
