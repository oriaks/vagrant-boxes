#!/bin/sh

if [ -d /android/system ]; then
  # Android specific
  dd if=/dev/zero of=/android/system/EMPTY bs=1048576
  rm -f /android/system/EMPTY
else
  # Pretty much everything else
  dd if=/dev/zero of=/EMPTY bs=1048576
  rm -f /EMPTY
fi

exit 0
