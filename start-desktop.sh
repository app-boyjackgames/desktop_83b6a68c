#!/bin/bash
set -eu

cleanup() {
    echo "Cleaning up..."
    kill $(jobs -p) 2>/dev/null || true
    rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 2>/dev/null || true
}
trap cleanup EXIT

rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 2>/dev/null || true

export HOME=/home/runner/workspace

mkdir -p "$HOME/.fluxbox"

export DISPLAY=:1

echo "Starting Xvfb..."
Xvfb :1 -screen 0 1024x768x24 &
sleep 2

echo "Starting Fluxbox..."
startfluxbox &
sleep 1

echo "Starting x11vnc on port 5900..."
x11vnc -display :1 -nopw -listen 0.0.0.0 -rfbport 5900 -forever -shared -noxdamage &

echo "Desktop is running."
