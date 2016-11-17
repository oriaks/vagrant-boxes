#!/bin/sh

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
