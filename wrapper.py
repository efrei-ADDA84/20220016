import os
import requests

API_KEY = os.environ.get('API_KEY')
LAT = os.environ.get('LAT')
LONG = os.environ.get('LONG')

def get_weather():
    url = f'https://api.openweathermap.org/data/2.5/weather?lat={LAT}&lon={LONG}&appid={API_KEY}&units=metric'
    response = requests.get(url)

    if response.status_code == 200:
        data = response.json()
        description = data['weather'][0]['description']
        temperature = data['main']['temp']
        return f"The weather at longitude {LONG} and latitude {LAT} is {description} with a {temperature} degrees Celsius"
    else:
        raise Exception(f"ERROR: {response.status_code}")

print(get_weather())