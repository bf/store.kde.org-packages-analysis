#-*- coding: UTF-8 -*-
import requests
from bs4 import BeautifulSoup
from sys import argv
script, url, selector = argv

URL = url
SELECTOR = selector
HEADERS = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Safari/537.36'}
def main():
    response = requests.get(URL, headers=HEADERS)
    if not response.ok:
        print(f"Failed to fetch the page: {response.reason}")
        return None 
    html_doc = response.text
    soup = BeautifulSoup(html_doc, 'html.parser')
    result = soup.select(SELECTOR)[0].text
    print(result)
main()
