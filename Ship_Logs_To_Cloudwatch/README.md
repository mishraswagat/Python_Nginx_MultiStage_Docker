# 📊 Step-by-Step Guide: Send Docker Container Logs to AWS CloudWatch  

Easily ship your Docker container logs directly to **AWS CloudWatch** without installing any extra agent. 🚀  

---

## 📝 1. Create a Log Group in CloudWatch  
1. Go to **AWS CloudWatch**  
2. On the left menu → **Log Groups**  
3. Click ➕ **Create Log Group**  
4. Enter a name (e.g., `nginx-logs`)  
5. Set:
   - **Retention**: 1 Day  
   - **Log Class**: Standard  
6. Click **Create** ✅  

---

## 👤 2. Create an IAM User  
1. Go to **AWS IAM**  
2. On the left menu → **Users** → **Create User**  
3. Enter username: `ec2` → Next  
4. Select **Attach Policies Directly**  
5. Choose ✅ `CloudWatchFullAccess` & `CloudWatchFullAccessV2`  
6. Validate & create user  
7. Generate an **Access Key** 🔑 (needed for CLI usage on the server where Docker will run).  

---

## 🔑 3. Create an IAM Role  
1. Go to **AWS IAM** → **Roles** → **Create Role**  
2. Select **AWS Services** as Trusted Entity  
3. Choose **EC2** from dropdown → Next  
4. Attach ✅ `CloudWatchFullAccess` & `CloudWatchFullAccessV2`  
5. Enter role name: `EC2-Nginx` → Create Role 🎉  

---

## ⚡ 4. Attach Role to EC2 Instance  
1. Go to **AWS EC2**  
2. Select your instance  
3. Click **Actions → Security → Modify IAM Role**  
4. Select role `EC2-Nginx` → Save / Update IAM Role  

---

## 📡 5. Monitor Docker Logs in CloudWatch  
- Use the provided `deploy.sh` script (already included in this repo).  
- The script runs the container with CloudWatch logging:  

```bash
docker run \
  --log-driver=awslogs \
  --log-opt awslogs-group=nginx-logs \
  --log-opt awslogs-region=us-east-1
```
👉 This ships logs directly to CloudWatch Logs via Docker’s native AWS log driver — no agents needed!

Once the container is running:

Go to AWS CloudWatch → Log Groups → nginx-logs

Open Log Streams to view real-time container logs 📖✨

✅ Summary

With just IAM setup + Docker’s log driver, your container logs are now available in AWS CloudWatch for monitoring & analysis. 🔥


## 🖼️ Architecture Diagram  

```ascii
+------------------+        docker run with        +------------------+
|                  |   --log-driver=awslogs        |                  |
|  Docker Container+------------------------------>+  AWS CloudWatch  |
|   (Nginx / App)  |   --log-opt awslogs-group     |   (Log Groups &  |
|                  |   --log-opt awslogs-region    |    Log Streams)  |
+------------------+                               +------------------+
         |
         | stdout / stderr
         v
   Application Logs
```