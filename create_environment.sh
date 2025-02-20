#!/bin/bash

# Prompt for user's name
read -p "Enter your name: " userName

# Validate user input
if [[ -z "$userName" ]]; then
    echo "Error: Name cannot be empty. Exiting."
    exit 1
fi

# Define the main directory name
main_dir="submission_reminder_${userName}"

# Check if directory already exists
if [[ -d "$main_dir" ]]; then
    echo "Error: Directory $main_dir already exists. Exiting."
    exit 1
fi

# Create the main directory and subdirectories
mkdir -p "$main_dir/app" "$main_dir/config" "$main_dir/modules" "$main_dir/assets"
echo "Creating project structure..."

# Create necessary files
touch "$main_dir/config/config.env"
touch "$main_dir/app/reminder.sh"
touch "$main_dir/modules/functions.sh"
touch "$main_dir/assets/submissions.txt"
touch "$main_dir/startup.sh"
touch "$main_dir/README.md"

# Populate config.env with sample configurations
cat << EOF > "$main_dir/config/config.env"
# Configuration File
ASSIGNMENT="Shell Scripting Project"
DAYS_REMAINING=3
EOF

# Populate submissions.txt with sample student records
cat << EOF > "$main_dir/assets/submissions.txt"
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Kellia, assignment, submission status
teta, Shell Navigation, not submitted
Aurore, Git, submitted
Divine, Shell Navigation, not submitted
blessing, Shell Basics, submitted
Dorcus,assignment,not submitted
EOF

# Populate functions.sh with a sample function
cat << 'EOF' > "$main_dir/modules/functions.sh"
#!/bin/bash

# Function to check student submissions
check_submissions() {
    local submissions_file="$1"
    echo "Checking submissions in $submissions_file"
    
    while IFS=, read -r student assignment status; do
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "Not Submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file")
}
EOF
chmod +x "$main_dir/modules/functions.sh"

# Populate reminder.sh with basic logic
cat << 'EOF' > "$main_dir/app/reminder.sh"
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

submissions_file="/assets/submissions.txt"

echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions "$submissions_file"
EOF
chmod +x "$main_dir/app/reminder.sh"

# Populate startup.sh to run the app
cat << 'EOF' > "$main_dir/startup.sh"
#!/bin/bash

echo "Starting the Submission Reminder App..."
bash ./app/reminder.sh
EOF
chmod +x "$main_dir/startup.sh"

# Populate README.md with instructions
cat << EOF > "$main_dir/README.md"
# Submission Reminder App

This application helps students track and receive alerts about upcoming assignment deadlines.

## Setup Instructions:
1. Run the setup script:
   \`\`\`
   chmod +x create_environment.sh
   ./create_environment.sh
   \`\`\`
2. Navigate to the created directory and start the app:
   \`\`\`
   cd submission_reminder_${userName}/scripts
   chmod +x startup.sh
   ./startup.sh
   \`\`\`

## Project Structure:
- \`config.env\` → Stores environment variables
- \`submissions.txt\` → Contains student assignment records
- \`reminder.sh\` → Handles reminder notifications
- \`functions.sh\` → Includes helper functions
- \`startup.sh\` → Starts the application

## Author:
Created by **${userName}**
EOF
echo "Setup complete! Running the application..."
cd "$main_dir"
./startup.sh

