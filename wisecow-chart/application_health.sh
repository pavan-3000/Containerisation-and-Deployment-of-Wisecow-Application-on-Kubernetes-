#!/bin/bash

# Define the application URL
URL="https://wisecow.example.com"

# Send an HTTP request to the application and get the status code (using -k to bypass SSL verification)
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -k $URL)

# Check if the status code is 200 (OK)
if [ "$STATUS_CODE" -eq 200 ]; then
    echo "The application is UP (HTTP Status Code: $STATUS_CODE)"
else
    echo "The application is DOWN (HTTP Status Code: $STATUS_CODE)"
fi

