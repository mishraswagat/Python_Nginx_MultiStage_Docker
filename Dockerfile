FROM python:3.9-slim as builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

FROM python:3.9-slim
# Install nginx & curl
RUN apt-get update && apt-get install -y nginx curl --no-install-recommends 

# Remove unwanted cache files to reduce bloating of final image
RUN rm -rf /var/lib/apt/lists/*

# Copy Python dependencies from builder stage
COPY --from=builder /root/.local/ /root/.local
COPY nginx.conf /etc/nginx/sites-available/default
COPY index.html /usr/share/nginx/html/

WORKDIR /app
COPY app.py .
COPY start.sh .

# Make the start script executable as well as remove default file and replace with new one
RUN chmod +x start.sh && rm /etc/nginx/sites-enabled/default && ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/


ENV PATH=/root/.local/bin:$PATH

# Force python output directly to terminal (no buffering)
ENV PYTHONUNBUFFERED=1

#Exposing Port
EXPOSE 80

#Starting both services
#CMD nginx -g "daemon off;" & python app.py --> The traditional way but we have start.sh for it.
CMD ["./start.sh"]

