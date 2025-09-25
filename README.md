# 🐍➡️🐳 Python + Nginx Multi-Stage Docker Project
A complete example of a multi-stage Docker setup featuring Python application with Nginx reverse proxy.

## 📋 Project Overview
This project demonstrates a multi-stage Docker build that:

 - 🐍 Runs a Python web application
 - 🌐 Serves static content via Nginx
 - 🔄 Uses Nginx as reverse proxy for API requests
 - 🐳 Optimizes Docker image size with multi-stage builds
 - 🚀 Production-ready structure
 
## 🏗️ Project Structure

```bash
python-nginx-docker/
├── Dockerfile              # Multi-stage Docker configuration
├── requirements.txt        # Python dependencies
├── app.py                 # Python web application
├── nginx.conf            # Nginx configuration
├── index.html            # Static HTML page
├── README.md             # This file
├── start.sh			  # This will start the services inside Container
├── deploy.sh 			  #Written the script to avoid writing docker commands repeatedly.
```

## 🚀 Quick Start
### Prerequisites
 - Docker installed on your system
 - Git
 
### Step 1: Clone or Create Project

Pull this repository to your machine using
```bash
git clone https://github.com/mishraswagat/Python_Nginx_MultiStage_Docker.git
```

Get inside the directory name **Python_Nginx_MultiStage_Docker**

### Step 2: Build the Docker Image

```bash
docker build -t python-nginx-app .
```
**Here i named the image as python-nginx-app , you can use your custom name**

***OR***

**Build with version tag**
```bash
docker build -t python-nginx-app:v1.0 .
```

### Step 3: Run the Container
```bash
docker run -d -p 80:80 --name python-nginx python-nginx-app
```
**Here i named the container as python-nginx , you can use your custom name**

***There is a deploy.sh which will help you to restart the container**

### Step 4: Access the Application

Open your browser and visit:

 - http://localhost - HTML interface
 - http://localhost/api - Python API
 - http://localhost/api/data - Sample data API
 - http://localhost/health - Health check
 
## Manage Container

```bash
# Stop container
docker stop python-nginx

# Start container
docker start python-nginx

# View logs
docker logs python-nginx

# Remove container
docker rm python-nginx
```

### Extras

**Get inside the container to check something. Example : NGINX Log**
```bash
docker exec -it python-nginx /bin/bash
```
if bash shell is not available 
```bash
docker exec -it python-nginx /bin/shell
```
Once you are inside the container , you will see your pwd is /app
Visit cd /var/log/nginx/ and read the file if required.
```bash
tail -f /var/log/nginx/access.log
```
### Monitor nginx error logs in real-time 
```bash 
tail -f /var/log/nginx/error.log
```

### From Host Machine (without entering container):

```bash
docker exec -it python-nginx tail -f /var/log/nginx/access.log
```
