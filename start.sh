#!/bin/bash
# Start nginx in background
nginx -g "daemon off;" &

# Start Python app in foreground
exec python app.py
