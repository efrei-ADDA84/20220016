import os
import requests
from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route('/weather', methods=['GET'])
def get_weather():
    API_KEY = os.environ.get('API_KEY')
    lat = request.args.get('lat')
    lon = request.args.get('lon')
    
    url = f'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API_KEY}&units=metric'
    response = requests.get(url)

    if response.status_code == 200:
        data = response.json()
        description = data['weather'][0]['description']
        temperature = data['main']['temp']
        return jsonify({
            'description': description,
            'temperature': temperature
        })
    else:
        return jsonify({'error': f'ERROR: {response.status_code}'})

if __name__ == '__main__':
    app.run()
