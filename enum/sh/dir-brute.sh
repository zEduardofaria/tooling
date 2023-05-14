#!/bin/bash

# Check if the required parameters are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <host> <wordlist>"
    exit 1
fi

host=$1
wordlist=$2

# Set the user agent to Mozilla browser
user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"

# Get the total number of lines in the wordlist
total_lines=$(wc -l < "$wordlist")

# Initialize counters
words_tested=0
words_found=0

# Function to update the progress bar
update_progress() {
    local progress=$1
    local max_length=$2

    local bar_length=$((max_length - 7))  # Leave space for the percentage

    # Calculate the percentage
    local percent=$((progress * 100 / total_lines))

    # Calculate the number of filled and empty spaces in the progress bar
    local filled_length=$((progress * bar_length / total_lines))
    local empty_length=$((bar_length - filled_length))

    # Create the progress bar string
    local progress_bar="["
    progress_bar+="$(printf '#%.0s' $(seq 1 "$filled_length"))"
    progress_bar+="$(printf ' %.0s' $(seq 1 "$empty_length"))"
    progress_bar+="]"

    # Print the progress bar, percentage, and absolute value of words tested
    printf "\r%s %3d%% (%d/%d)" "$progress_bar" "$percent" "$progress" "$total_lines"
}

# Iterate over each word in the wordlist
while IFS= read -r word; do
    # Make the GET request with curl and check the status code
    response_code=$(curl -s -o /dev/null -w "%{http_code}" -A "$user_agent" "$host/$word")

    if [ "$response_code" = "200" ]; then
        echo "Found: $host/$word"
        words_found=$((words_found + 1))
    fi

    words_tested=$((words_tested + 1))

    # Update the progress bar
    update_progress "$words_tested" 50
done < "$wordlist"

echo  # Move to the next line after the progress bar
echo "Words tested: $words_tested"
echo "Words found: $words_found"