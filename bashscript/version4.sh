#!/bin/bash

# ---- Local directory setup ----
localDir="/home/$USER/local-reports"
zipFolder="/home/$USER/zipped_reports"
zipArchive="/home/$USER/zipArchive"

echo "printing localDir: $localDir"
mkdir -p "$localDir" "$zipFolder" "$zipArchive"

# ---- Move existing ZIPs to archive ----
echo "Moving ZIP files from $zipFolder to $zipArchive..."
shopt -s nullglob
for zipFile in "$zipFolder"/*.zip; do
    mv "$zipFile" "$zipArchive/"
    echo "Moved $(basename "$zipFile") to $zipArchive"
done
shopt -u nullglob

# ---- Generate service status report ----
reportFile="$localDir/$(hostname)_system_report.txt"
echo "$reportFile"

echo "==============================================" > "$reportFile"
echo "         SYSTEM STATUS REPORT - $(hostname)" >> "$reportFile"
echo "==============================================" >> "$reportFile"

if ! command -v systemctl &> /dev/null; then
    echo "Error: systemctl not found. This script requires systemd." >> "$reportFile"
    exit 1
fi

{
    echo "------ RUNNING SERVICES ------"
    systemctl list-units --type=service --state=running --no-pager --no-legend \
        | awk '{print $1 "\t" $4}' | sort
    echo

    echo "------ STOPPED SERVICES ------"
stopped_services=$(systemctl list-units --type=service --state=inactive --no-pager --no-legend \
    | awk '{print $1}' | grep '\.service$' | sed '/^$/d' \
    | grep -Ev '^(initrd-|systemd-hibernate|systemd-hybrid-sleep|systemd-suspend|emergency|rescue|reboot|halt|poweroff|kexec|systemd-shutdown)' )

echo "print stopped services variable: $stopped_services"


echo "------ FAILED SERVICES ------"
    systemctl list-units --type=service --state=failed --no-pager --no-legend \
        | awk '{print $1 "\t" $4}' | sort
    echo

    echo "=============================================="
    echo " Total Running:  $(systemctl list-units --type=service --state=running | grep -c '.service')"
    echo " Total Stopped:  $(systemctl list-units --type=service --state=inactive | grep -c '.service')"
    echo " Total Failed :  $(systemctl list-units --type=service --state=failed | grep -c '.service')"
    echo "=============================================="
    echo

    echo "------ DISK USAGE (df -h) ------"
    df -h
    echo

    echo "------ BLOCK DEVICES (lsblk) ------"
    lsblk
    echo

    echo "------ STORAGE USAGE OF HOME DIRECTORY ------"
    du -sh /home/$USER
    echo

    
    echo "------ ZOMBIE PROCESSES ------"
    zombies=$(ps -eo pid,ppid,state,cmd | awk '$3=="Z"')
    if [ -z "$zombies" ]; then
        echo " No zombie processes found."
    else
        echo " Zombie processes detected:"
        echo "$zombies"
        echo
        echo "Note: Zombie processes are dead but not yet cleaned up by their parent."
        echo "You may need to restart the parent process (PPID) to clean them."
    fi
    echo

} >> "$reportFile"



hostname -I >> "$localDir/private_ip.txt"
echo " Private IP addresses saved to $localDir/private_ip.txt"

curl ifconfig.me >> "$localDir/public_ip.txt"
echo " Public IP address saved to $localDir/public_ip.txt"


# ---- Check if zip is installed ----
if ! command -v zip &> /dev/null; then
    echo " zip command not found. Installing zip..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y zip
    else
        echo " Unsupported package manager. Please install zip manually."
        exit 1
    fi
fi

# ---- Create ZIP file ----
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