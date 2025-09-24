# 📊 Step-by-Step Guide: Send Docker Container Logs to AWS CloudWatch 

## Mount volumes for Nginx logs and Python logs so CloudWatch Agent on EC2 can read them.

## Configure CloudWatch Agent to watch Docker JSON logs and those mounted paths.

### 1. Run your container with log volumes

 -- As our image name is python-nginx-app 
 We need to mount volume
 ```bash
 docker run -d  --name python-nginx -p 80:80 -v /var/log/nginx:/var/log/nginx -v /home/ec2-user/app-logs:/app/logs python-nginx-app
 ```
 
  - /var/log/nginx on the EC2 host will now have the nginx logs from the container.

  - /home/ec2-user/app-logs on the EC2 host will now have your Python logs.
  
 ### 2. Install CloudWatch Agent on EC2
 ```bash
 sudo yum install -y amazon-cloudwatch-agent 
 ```
 ### 3. Create CloudWatch Agent Config
  -- You can run the wizard or create config manually.
  ***OR***
  Here’s a manual config file /opt/aws/amazon-cloudwatch-agent/bin/config.json:
  ```bash
  {
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/lib/docker/containers/*/*.log",
            "log_group_name": "docker-logs",
            "log_stream_name": "{instance_id}"
          },
          {
            "file_path": "/var/log/nginx/access.log",
            "log_group_name": "nginx-access",
            "log_stream_name": "{instance_id}"
          },
          {
            "file_path": "/var/log/nginx/error.log",
            "log_group_name": "nginx-error",
            "log_stream_name": "{instance_id}"
          },
          {
            "file_path": "/home/ec2-user/app-logs/app.log",
            "log_group_name": "python-app",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
```

### 4. Start CloudWatch Agent
```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json \
  -s
```
Check status:
```
sudo systemctl status amazon-cloudwatch-agent
```

### 5. Verify in AWS Console

 - Open CloudWatch → Log groups

 - You’ll see:

   - docker-logs → raw container logs (stdout/stderr)

   - nginx-access, nginx-error → Nginx logs  

   - python-app → your Python logs

