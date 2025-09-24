FROM python:3.9-slim as builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

FROM python:3.9-slim
# Install dependencies
RUN apt-get update && \
    apt-get install -y nginx curl --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Copy files
COPY --from=builder /root/.local/ /root/.local
COPY nginx.conf /etc/nginx/sites-available/default
COPY index.html /usr/share/nginx/html/
WORKDIR /app
COPY app.py .
COPY start.sh .

# Make start script executable
RUN chmod +x start.sh && \
    rm /etc/nginx/sites-enabled/default && \
    ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

ENV PATH=/root/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

EXPOSE 80
CMD ["./start.sh"]
