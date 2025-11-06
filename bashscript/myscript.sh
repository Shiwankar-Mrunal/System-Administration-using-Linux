#!/bin/bash

# ---- Local directory setup ----
localDir="/home/$USER/local-reports"
zipFolder="/home/$USER/zipped_reports"
zipArchive="/home/$USER/zipArchive"

if [ -d "$localDir" ]; then
    echo "The folder'$FOLDER' already exists."
else
    echo "The folder '$localDir' does not exist. Creating it now..."
    mkdir -p "$localDir"
    echo "Folder '$localDir' created successfully."
fi

if [ -d "$zipArchive" ]; then
    echo "The folder'$zipArchive' already exists."
else
    echo "The folder '$zipArchive' does not exist. Creating it now..."
    mkdir -p "$zipArchive"
    echo "Folder '$zipArchive' created successfully."
fi

# ---- Move existing ZIPs to archive ----
echo "Moving ZIP files from $zipFolder to $zipArchive..."
shopt -s nullglob
for zipFile in "$zipFolder"/*.zip; do
    mv "$zipFile" "$zipArchive/"
    echo "Moved $(basename "$zipFile") to $zipArchive"
    echo "Error: Failed to move information."
    exit 1   
done
shopt -u nullglob

echo "-------1. stopped Services --------"

if systemctl list-units --type=service --state=inactive  >> "$localDir/stopped_services.txt"; then
    echo "Stopped services information added successfully."
else
    echo "Error: Failed to retrieve stopped services information."
    exit 1
fi


echo "-------  Running Services --------"


if systemctl list-units --type=service --state=running  >> "$localDir/running_services.txt"; then
    echo "Running services information added successfully."
else
    echo "Error: Failed to retrieve running services information."
    exit 1
fi


echo "-------  Failed Services --------"

if systemctl list-units --type=service --state=failed  >> "$localDir/failed_services.txt"; then
    echo "Failed services information added successfully."
else
    echo "Error: Failed to retrieve failed services information."
    exit 1
fi

#----- Generate  memory usage report -----

if df -h >> "$localDir/disk_usage.txt"; then
    echo "Disk usage information added successfully."
else
    echo "Error: Failed to retrieve disk usage information."
    exit 1
fi

# ----------CPU/memory usage by services ---------

if top -b -n 1 >> "$localDir/cpu_memory_usage_by_processes.txt"; then
    echo "Memory usage infor added successfully."
else
    echo "Error: Failed to add memory usage information."
    exit 1
fi

# hostName 
if hostname -f >> "$localDir/host_name.txt"; then
    echo "Host name info added successfully."
else
    echo "Error: Failed to retrieve host name information."
    exit 1
fi

# Network Information
if ip addr >> "$localDir/network_info.txt"; then 
    echo "Network information added successfully."
else
    echo "Error: Failed to retrieve network information."
    exit 1
fi

#  list of logged in users 
if who >> "$localDir/logged_in_users.txt"; then
    echo "Logged in  information added successfully."
else
    echo "Error: Failed to retrieve logged in users information."
    exit 1
fi

if hostname -I; then
    echo " Private IP addresses fetched successfully."
else
    echo "Error: Failed to fetch private IP addresses."
    exit 1
fi

if curl ifconfig.me; then
    echo " Public IP address fetched successfully."
else
    echo "Error: Failed to fetch public IP address."
    exit 1
fi


#-------check if zip is installed -----
if ! command -v zip &> /dev/null; then
    echo " zip command not found. Installing zip..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y zip
    else
        echo " Unsupported package manager. Please install zip manually."
        exit 1
    fi
fi
   

#-------create zip file -----------
zipFileName="$zipFolder/service_report_$(date +%Y%m%d%H%M%S).zip"
echo "Creating ZIP file: $zipFileName"
zip -r "$zipFileName" "$localDir"

if [ $? -eq 0 ]; then
    echo " ZIP file created successfully."
    echo "Deleting local-reports directory..."
    rm -rf "$localDir"
else
    echo " Failed to create ZIP file. Exiting script."
    exit 1
fi

