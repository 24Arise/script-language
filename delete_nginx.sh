#!/bin/bash

# Delete nginx processes in batches
for pid in $(ps -ef | grep nginx | grep -v "grep" | awk '{print $2}'); do
  kill -9 ${pid}
done
