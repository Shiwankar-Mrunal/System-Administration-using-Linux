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
    # echo "Error: Failed to move information."
    exit 1   
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

    echo "------ RUNNING SERVICES ------"
    systemctl list-units  --no-pager --no-legend \
        | awk '{print $1 "\t" $4}' | sort || >> "$localDir/running_services.txt" {
            echo "Error: Failed to list running services." 
            exit 1 }
