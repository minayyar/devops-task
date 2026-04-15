# GCP DevOps Task (No IAP Version)

## 📌 Overview
This project deploys:

- Custom VPC
- Subnet
- Firewall rules
- Compute Engine VM (e2-micro)
- Nginx web server

---

## 🔐 Security Model

- HTTP/HTTPS open to internet
- SSH restricted to YOUR IP only
- No IAP required (permission-safe)

---

## 🚀 Deployment

terraform init  
terraform apply -var="project_id=YOUR_PROJECT" -var="my_ip=YOUR_IP/32"

---

## 🌐 Access

http://<external-ip>

---

## 🔑 SSH Access

ssh username@<external-ip>

(only works from your IP)

---

## 🧹 Destroy

terraform destroy -auto-approve

---

## 💯 Production Concepts Covered

- Custom VPC
- Firewall segmentation
- Restricted SSH access
- Infrastructure as Code
- Secure-by-design thinking
