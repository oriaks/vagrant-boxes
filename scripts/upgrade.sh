#!/bin/sh

# CoreOS specific
if which update_engine_client; then
  update_engine_client -update ||:
fi

# Debian specific
if which apt-get; then
  apt-get update -y
  apt-get dist-upgrade -y
fi

# Red Hat specific
if which yum; then
  yum upgrade -y
fi

exit 0
