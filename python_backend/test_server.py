from flask import Flask
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/')
def home():
    return "Python server is running!"

@app.route('/api/message')
def message():
    return {"message": "Hello from Python!"}

if __name__ == '__main__':
    app.run(debug=True, port=5000)