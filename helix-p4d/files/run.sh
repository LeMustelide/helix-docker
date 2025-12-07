#!/bin/bash
# Run the initialization
init.sh

# Start the main process (tail in this case)
# Using 'exec' here replaces the shell with the tail process,
# ensuring tail becomes PID 1 and receives signals.
exec /usr/bin/tail -F $P4ROOT/logs/log