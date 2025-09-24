from bottle import Bottle, run

app = Bottle()

@app.route('/api')
def api():
    return {"message": "Hello from SWAGAT", "status": "success"}

@app.route('/api/health')
def health():
    return {"status": "healthy", "service": "python-api"}

@app.route('/api/data')
def data():
    return {"data": [1, 2, 3, 4, 5], "count": 5}

if __name__ == "__main__":
    run(app, host='0.0.0.0', port=5000, debug=True)