#!/bin/bash

# Prompt for your name
echo "Enter your name:"
read user_name

# Define main directory and folder structure
main_dir="submission_reminder_${user_name}"
mkdir -p "$main_dir/app"
mkdir -p "$main_dir/assets"
mkdir -p "$main_dir/config"
mkdir -p "$main_dir/modules"

# Create reminder.sh inside the app folder
cat > "$main_dir/app/reminder.sh" <<EOL
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: \$ASSIGNMENT"
echo "Days remaining to submit: \$DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions \$submissions_file
EOL

# Create config.env inside the config folder
cat > "$main_dir/config/config.env" <<EOL
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOL

# Create functions.sh inside the modules folder
cat > "$main_dir/modules/functions.sh" <<EOL
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=\$1
    echo "Checking submissions in \$submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=\$(echo "\$student" | xargs)
        assignment=\$(echo "\$assignment" | xargs)
        status=\$(echo "\$status" | xargs)

        # Check if assignment matches and status is 'not submitted' or 'submitted'
        if [[ "\$assignment" == "\$ASSIGNMENT" && "\$status" == "not submitted" ]]; then
            echo "Reminder: \$student has not submitted the \$ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "\$submissions_file") # Skip the header
}
EOL

# Create submissions.txt inside the assets folder
cat > "$main_dir/assets/submissions.txt" <<EOL
student, assignment, submission status
Grace, Shell Navigation, not submitted
Michael, Git, submitted
Samuel, Shell Navigation, not submitted
Sophia, Shell Basics, submitted
Ethan, Shell Basics, submitted
Olivia, Shell Navigation, submitted
Liam, Git, not submitted
Noah, Git, submitted
Emma, Shell Basics, not submitted
Ava, Shell Navigation, submitted
William, Shell Navigation, not submitted
James, Git, submitted
Benjamin, Shell Basics, not submitted
Charlotte, Shell Basics, submitted
Amelia, Shell Navigation, submitted
Lucas, Git, not submitted
Henry, Shell Navigation, not submitted
Alexander, Git, submitted
Mia, Shell Basics, not submitted
Harper, Shell Navigation, submitted
Elijah, Shell Basics, submitted
Daniel, Git, not submitted
Sebastian, Shell Navigation, submitted
Jack, Shell Basics, not submitted
Aiden, Git, submitted
Chloe, Shell Navigation, not submitted
Emily, Git, submitted
Evelyn, Shell Basics, not submitted
Scarlett, Shell Navigation, submitted
Zoe, Git, not submitted
Nathan, Shell Basics, submitted
Lily, Git, submitted
Hannah, Shell Navigation, not submitted
Ryan, Shell Basics, not submitted
Carter, Git, submitted
Madison, Shell Navigation, submitted
Owen, Shell Basics, not submitted
Ella, Git, submitted
EOL

# Create startup.sh in the main directory
cat > "$main_dir/startup.sh" <<EOL
#!/bin/bash

# Check if the main directory exists
if [ ! -d "$main_dir" ]; then
    echo "Error: Directory $main_dir does not exist!"
    exit 1
fi

# Navigate to the main directory
cd "$main_dir" || exit 1

# Run the reminder script
echo "Starting reminder application..."
./app/reminder.sh
echo "Reminder app started successfully!"
EOL

# Make all .sh files executable
chmod +x "$main_dir/app/reminder.sh"
chmod +x "$main_dir/modules/functions.sh"
chmod +x "$main_dir/startup.sh"

# Output success message
echo "Directory structure and files have been created successfully!"
echo "You can run the reminder app using ./$main_dir/startup.sh"
