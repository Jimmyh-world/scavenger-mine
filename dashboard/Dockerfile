FROM python:3.11-slim

WORKDIR /app

# Create a simple Flask app to serve the dashboard
RUN pip install --no-cache-dir Flask gunicorn

# Copy dashboard files
COPY index.html .
COPY styles.css .

# Create Flask app
RUN cat > app.py << 'EOF'
from flask import Flask, send_file, send_from_directory
import os

app = Flask(__name__, static_folder='.', static_url_path='')

@app.route('/')
def index():
    return send_file('index.html')

@app.route('/styles.css')
def styles():
    return send_file('styles.css')

@app.route('/health')
def health():
    return {'status': 'healthy'}, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
EOF

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --retries=3 --start-period=20s \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')" || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "app:app"]
