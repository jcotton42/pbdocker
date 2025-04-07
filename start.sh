#!/bin/bash

export APPDIR=/app/pb
export DISPLAY=:0

mkdir -p /app/data/data /app/data/config

Xvfb "$DISPLAY" > /dev/null 2>&1 &
/app/PushoverStub/PushoverStub &
cd "$APPDIR"
# --no-sandbox is workaround for "The SUID sandbox helper binary was found, but
# is not configured correctly. Rather than run without sandboxing I'm aborting
# now" error
./AppRun --server --no-sandbox &
wait
