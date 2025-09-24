from bottle import Bottle, run
import logging
import os

# Make sure the logs directory exists
os.makedirs("/app/logs", exist_ok=True)

logging.basicConfig(
    filename="/app/logs/app.log",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

app = Bottle()

@app.route('/api')
def api():
    logging.info("API /api endpoint was called")
    return {"message": "Hello From Python", "status": "success"}

@app.route('/api/health')
def health():
    logging.info("Health check called")
    return {"status": "healthy", "service": "python-api"}

@app.route('/api/data')
def data():
    logging.info("Data endpoint called, returning 5 items")
    return {"data": [1, 2, 3, 4, 5], "count": 5}

if __name__ == "__main__":
    run(app, host='0.0.0.0', port=5000, debug=True)
