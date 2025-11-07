# System Administration Automation (BASH)

## This project is designed to provide practical experience in automating system administration tasks through Bash scripting, Azure Cloud services, and monitoring tools. It replicates real-world scenarios such as system monitoring, log analysis, report generation, and cloud-based deployment, enabling you to develop a solid foundation in managing and automating distributed infrastructure



## Step 1 : Create vm for monitoring 

Creating One VM with script following link mention for script details

https://github.com/Shiwankar-Mrunal/System-Administration-using-Linux/blob/main/VM-script.txt

## Step 2 : Create test vm for manually with name and id 

## Step 3 : run following SystemMonitoring script in test vm to fetch vm data for monitoring

- Stopped Services 
- Running Services 
- Failed Services 
- Disk Usage 
- CPU & Memory Usage by Processes  
- Hostname 
- Network Information 
- Logged-in Users 
- Private IP Address 
- Public IP Address 

https://github.com/Shiwankar-Mrunal/System-Administration-using-Linux/blob/main/version3.sh

## step 4 : Establish connection between two vm

````
scp TestServerUserName@testserverip:/home/mrunal/zipped_reports/service_report_20251102151643.zip /home/mrunal/zipped_reports
````

## Step 5 : Fetch Data from one to another vm and get zip file

# Monitoring real time application

- Immediate Detection of Failures
- Performance Tracking
- Auto-Healing Triggers
- Audit and Reporting


# Future Scope 
 
- Dashboard on Azure App Service 
- Weekly report 
- splunk for monitoring 
