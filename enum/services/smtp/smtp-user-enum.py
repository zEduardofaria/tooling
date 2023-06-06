import smtplib
import sys

def verify_user(smtp_host, smtp_port, wordlist):
    # Read the wordlist from a file
    with open(wordlist, 'r') as file:
        users = file.read().splitlines()

    # Connect to the SMTP server
    server = smtplib.SMTP(smtp_host, smtp_port)
    server.ehlo()

    for user in users:
        # Try to verify the existence of the user
        try:
            code, message = server.verify(user)
            if code == 250:
                print(f'The user {user} exists.')
            else:
                print(f'The user {user} does not exist.')
        except smtplib.SMTPException as e:
            print(f'Error while verifying the user {user}: {e}')

    # Close the connection to the SMTP server
    server.quit()

# Check if all the arguments are provided
if len(sys.argv) != 4:
    print("Usage: smtp-user-enum.py <smtp_host> <smtp_port> <wordlist>")
else:
    # Get the arguments from the command line
    smtp_host = sys.argv[1]
    smtp_port = int(sys.argv[2])
    wordlist = sys.argv[3]

    verify_user(smtp_host, smtp_port, wordlist)
