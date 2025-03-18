#!/bin/bash
set -e

# Kill existing Polybar instances
pkill -x polybar || true

# Wait for Polybar to exit
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch Polybar on all monitors
if command -v xrandr > /dev/null; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload toph >> /tmp/polybar_$m.log 2>&1 &
  done
else
  polybar --reload toph >> /tmp/polybar_single.log 2>&1 &
fi

