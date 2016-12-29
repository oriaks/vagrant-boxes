#!/bin/sh

if [ -f /etc/machine-id ]; then
  :>/etc/machine-id
fi

exit 0
