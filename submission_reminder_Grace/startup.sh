#!/bin/bash

# Check if the main directory exists
if [ ! -d "submission_reminder_Grace" ]; then
    echo "Error: Directory submission_reminder_Grace does not exist!"
    exit 1
fi

# Navigate to the main directory
cd "submission_reminder_Grace" || exit 1

# Run the reminder script
echo "Starting reminder application..."
./app/reminder.sh
echo "Reminder app started successfully!"
