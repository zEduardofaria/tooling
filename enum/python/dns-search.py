import subprocess
import sys

# List of DNS record types to search for
record_types = ['A', 'AAAA', 'CNAME', 'MX', 'NS', 'TXT']

# Retrieve the domain name from command-line arguments
if len(sys.argv) < 2:
    print("Please provide a domain name as an argument.")
    sys.exit(1)

domain = sys.argv[1]

for record_type in record_types:
    # Construct the command to execute
    command = ['host', '-t', record_type, domain]

    try:
        # Execute the command and capture the output
        output = subprocess.check_output(command, universal_newlines=True)

        # Display the output
        print(f"DNS search result for record type '{record_type}':")
        print(output)
        print('-' * 40)
    except subprocess.CalledProcessError as e:
        # An error occurred while executing the command
        print(f"Error executing command: {e}")
