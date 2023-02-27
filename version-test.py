import datetime
import requests
import time

if __name__ == '__main__':
    while True:
        req = requests.get('http://localhost:8080/version')
        resp = req.json()
        now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        version = resp['version']
        print(f'{now} version: {version}')
        time.sleep(1)

