#!/bin/bash 

echo "Creating the main directory: submission_reminder_app"
mkdir -p submission_reminder_app 
cd submission_reminder_app
echo "Creating subdirectories..."
mkdir -p app
mkdir -p modules
mkdir -p assets
mkdir -p config
touch startup.sh
echo "Creating placeholder files..."
touch app/reminder.sh
touch modules/functions.sh 
touch assets/submissions.txt
touch config/config.env
echo "Give files executable permissions"
chmod +x app/reminder.sh
chmod +x modules/functions.sh
echo "Creating config.env..."
cat <<EOL > config/config.env
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOL
echo "Creating reminder.sh..."
cat <<EOL > app/reminder.sh
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
echo "Creating functions.sh..."
cat <<EOL > modules/functions.sh
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

        # Check if assignment matches and status is 'not submitted'
        if [[ "\$assignment" == "\$ASSIGNMENT" && "\$status" == "not submitted" ]]; then
            echo "Reminder: \$student has not submitted the \$ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "\$submissions_file") # Skip the header
}
EOL
echo "Adding new student records to submissions.txt..."
cat ../submissions.txt > ../submission_reminder_app/assets/submissions.txt
cat <<EOL >> ../submission_reminder_app/assets/submissions.txt
Student6, Assignment1, submitted
Student7, Assignment2, not submitted 
Student8, Assignment3, submitted
Student9, Assignment4, not submitted
Student10, Assignment5, submitted
EOL
echo "Write content for the startup.sh file"
cat <<EOL > startup.sh
#!/bin/bash

./app/reminder.sh
EOL
echo "give the file executable permissions"
chmod +x startup.sh
