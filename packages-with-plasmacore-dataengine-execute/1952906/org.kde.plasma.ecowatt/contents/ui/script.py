#-*- coding: UTF-8 -*-
import requests
import re
from bs4 import BeautifulSoup
from sys import argv

# get arguments
script, url, selector, regexp_normal, regexp_alert, regexp_threat = argv

URL = url
SELECTOR = selector
HEADERS = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Safari/537.36'}

def getPageValue():
    response = requests.get(URL, headers=HEADERS)
    if not response.ok:
        #print(f"Failed to fetch the page: {response.reason}")
        return None 
    html_doc = response.text
    soup = BeautifulSoup(html_doc, 'html.parser')
    result = soup.select(SELECTOR)[0].text
    return result
    
def main():
    result = getPageValue()
    #result = " bienvenus " # for testing

    if result:
        is_normal = re.search(regexp_normal, result)
        is_alert = re.search(regexp_alert, result)
        is_threat = re.search(regexp_threat, result)

        if is_normal: # > 0
            print('normal')
        elif is_alert: # > 0
            print('alert')
        elif is_threat: # > 0
            print('threat')
        else:
            print('none')
    else:
        print('error')

main()
