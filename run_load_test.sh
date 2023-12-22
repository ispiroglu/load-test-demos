#!/bin/bash

# Default values
process_id=""
total_seconds=30

# Parse named arguments
while getopts ":p:t:" opt; do
    case $opt in
        p)
            process_id=$OPTARG
            ;;
        t)
            total_seconds=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

# Check if process ID is provided
if [ -z "$process_id" ]; then
    echo "Process ID is required. Usage: $0 -p <process_id> [-t <total_seconds>]"
    exit 1
fi

# Start memory usage monitoring
memory_stats_report_file_name="run-reports/report-$process_id.log"
if [ -e "$memory_stats_report_file_name" ]; then
    rm "$memory_stats_report_file_name"
    echo "Former memory stats report for process cleared: '$memory_stats_report_file_name'"
fi

./process_memory_stats.sh -p "$process_id" -t "$total_seconds" >> "$memory_stats_report_file_name" &
pid_process_memory_stats=$!
echo "Memory usage monitoring started with PID $pid_process_memory_stats"

# Run load test with k-load



wait $pid_process_memory_stats
