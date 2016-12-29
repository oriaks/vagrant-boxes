#!/bin/sh

# CoreOS specific
if which timedatectl; then
  timedatectl set-timezone America/Toronto
fi

# macOS specific
if which systemsetup; then
  systemsetup -settimezone America/Toronto
fi
