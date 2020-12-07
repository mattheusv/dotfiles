#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if polybar -m | grep -q HDMI1; then
    export MONITOR=HDMI1
else
    export MONITOR=$(polybar -m|tail -1|sed -e 's/:.*$//g')
fi

exec polybar --reload main
