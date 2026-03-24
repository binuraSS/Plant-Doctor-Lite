from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)

# Configure CORS properly
CORS(app, origins=['http://localhost:54600', 'http://127.0.0.1:54600', 'http://localhost:5000', '*'])

@app.route('/api/message', methods=['GET', 'OPTIONS'])
def get_message():
    if request.method == 'OPTIONS':
        return '', 200
    return jsonify({
        'message': 'Hello from Python!',
        'counter_value': 42,
        'status': 'success'
    })

@app.route('/api/increment/<int:value>', methods=['GET', 'OPTIONS'])
def increment_counter(value):
    if request.method == 'OPTIONS':
        return '', 200
    new_value = value + 1
    return jsonify({
        'new_counter': new_value,
        'message': f'Counter incremented from {value} to {new_value}'
    })

if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5000)