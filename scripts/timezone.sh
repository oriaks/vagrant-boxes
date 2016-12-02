#!/bin/sh

# CoreOS specific
if which timedatectl; then
  timedatectl set-timezone America/Toronto
fi
