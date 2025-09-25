# Stage 1 : Python Dependencies

FROM python:3.9-slim as builder  
#used the name builder to call this later.

# Setting default work directory as /app ,later we will copy files to this location.
WORKDIR /app 

#This file contains external python package info that needs to be installed.
COPY requirements.txt . 

#installing the external packages
RUN pip install --user --no-cache-dir -r requirements.txt 

# --user used to install packages at /root/.local instead of the default /usr/local/lib/python3.9/site-packages/
# --no-cache-dir used to leave cache files,else it will bloat the image later. normally it keeps the cache files at /root/.cache/pip/

# Stage 2 : Building Final Image

FROM python:3.9-slim

# Install nginx & curl

RUN apt-get update && apt-get install -y nginx curl --no-install-recommends 

# Remove unwanted cache files to reduce bloating of final image
RUN rm -rf /var/lib/apt/lists/*

#Copying nginx static files 

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html

# Copy Python dependencies from builder stage

COPY --from=builder /root/.local/ /root/.local

WORKDIR /app

COPY app.py .

COPY start.sh .

# Make the start script executable as well as remove default file and replace with new one

RUN chmod +x start.sh && rm /etc/nginx/sites-enabled/default && ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/


# Set new Environment 
ENV PATH=/root/.local/bin:$PATH

# Force python output directly to terminal (no buffering)
ENV PYTHONUNBUFFERED=1

#Exposing Port
EXPOSE 80

#Starting both services
#CMD nginx -g "daemon off;" & python app.py --> The traditional way but we have start.sh for it.
CMD ["./start.sh"]


