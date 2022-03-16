#!/usr/bin/bash

export APPLICATION=mafia
cd ~/mafia-game
# git pull
MIX_ENV=prod mix deps.get
MIX_ENV=prod mix release --overwrite --path ~/mafia-game/releases/$APPLICATION $APPLICATION
sudo setcap 'cap_net_bind_service=+ep' ~/mafia-game/releases/$APPLICATION/erts-12.1.5/bin/beam.smp
# echo "JZVHQ4B6IQEBFHR34QMYMOEPBKN7FMFH5T3G5BEJ2ANQAW5RCH5Q====" > ~/mafia-game/releases/$APPLICATION/releases/COOKIE
