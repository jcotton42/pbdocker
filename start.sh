#!/bin/bash

cleanup() {
    pkill postybirb-plus
}

trap cleanup SIGTERM

export APPDIR=/home/postybirb/app
export DISPLAY=:0

mkdir -p /home/postybirb/data/data /home/postybirb/data/config

cd "$APPDIR"
Xvfb :0 > /dev/null 2>&1 &
# --no-sandbox is workaround for "The SUID sandbox helper binary was found, but
# is not configured correctly. Rather than run without sandboxing I'm aborting
# now" error
./AppRun --server --no-sandbox &
wait $!
