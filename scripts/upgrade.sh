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

# macOS specific
if which softwareupdate; then
  killall -9 softwareupdated
  rm -rf /Library/Updates
  defaults delete '/Library/Preferences/com.apple.SoftwareUpdate.plist' RecommendedUpdates

  softwareupdate -a -i

  TRAVIS=1 sudo -EHu vagrant ruby -e "$(curl -fLsS https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Red Hat specific
if which yum; then
  yum upgrade -y
fi

exit 0
