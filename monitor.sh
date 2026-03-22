#!/bin/bash

CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

alert() {
    echo "⚠️ ALERT: $1 usage is above threshold!"
}

while true
do
   #get cpu stats and pick cpu line using grep, awk to get exact idle%, remove decimal and store variable $()
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d'.' -f1)
    
   #$2 is total mem/used mem($3)
    mem_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}' | cut -d'.' -f1)
 
    #$5 for use% and sed to replace % and remove % globally 
    disk_usage=$(df / | grep / | awk '{print $5}' | sed 's/%//g')

    echo "CPU: $cpu_usage% | Memory: $mem_usage% | Disk: $disk_usage%"

    if [ "$cpu_usage" -gt "$CPU_THRESHOLD" ]; then
        alert "CPU"
    fi

    if [ "$mem_usage" -gt "$MEM_THRESHOLD" ]; then
        alert "Memory"
    fi

    if [ "$disk_usage" -gt "$DISK_THRESHOLD" ]; then
        alert "Disk"
    fi

    echo "----------------------------"
    #waits 5 seconds before next check
    sleep 5
done
