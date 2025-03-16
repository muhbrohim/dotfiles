#!/bin/bash

# Kill existing Polybar instances
pkill -x polybar

# Wait for Polybar to exit
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch Polybar on all monitors
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload toph &
  done
else
  polybar --reload toph &
fi

