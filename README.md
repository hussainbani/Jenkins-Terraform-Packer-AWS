# Jenkins-Terraform-Packer-AWS
This Pipeline automates 3tier node app. "WEB --> API --> RDS". All build is deployed without downtime.

This does the following things:
1) Creates AMI using packer
2) Configuration Management using ansible
3) Deployment using terraform which includes following resources:
	1) ASG and ALB for API & WEB
	2) S3 Bucket for logs using cron
	3) RDS 
	4) Cloudfront

Terraform is configured in a way that when a new build is made, a new AMI is created and New ASG and LC is created without downtime. i.e. new one is first created and then older one is destroyed.
