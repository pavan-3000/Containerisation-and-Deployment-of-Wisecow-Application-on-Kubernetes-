#!/bin/bash
echo "Starting system health monitoring..."

# Example CPU usage check
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
echo "CPU Usage: $CPU_USAGE%"

# Example Memory usage check
MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
echo "Memory Usage: $MEM_USAGE%"

# Example Disk space check
DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
echo "Disk Space Usage: $DISK_USAGE%"

# Example check for running processes
PROCESS_COUNT=$(ps aux | wc -l)
echo "Running Processes: $PROCESS_COUNT"

# Check thresholds and alert if necessary
if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
    echo "Alert: CPU usage is high at $CPU_USAGE%"
fi

if (( $(echo "$MEM_USAGE > 80" | bc -l) )); then
    echo "Alert: Memory usage is high at $MEM_USAGE%"
fi

if (( DISK_USAGE > 80 )); then
    echo "Alert: Disk usage is high at $DISK_USAGE%"
fi

if (( PROCESS_COUNT > 500 )); then
    echo "Alert: There are too many running processes: $PROCESS_COUNT"
fi

echo "System health check completed."

