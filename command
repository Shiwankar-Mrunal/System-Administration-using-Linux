scp mrunal@132.220.2.48:/home/mrunal/zipped_reports/service_report_20251102151643.zip /home/mrunal/zipped_reports

chmod +x script.sh

#Command to fetch privete ip address

    Method 1: Using the ip addr Command to Check IP address in linux
        ip addr show

    Method 2: Using hostname -I Command to Check IP address in linux
        hostname -I
 

#command to fetch public ip address

    1.Using curl Command to Check IP address in linux
        curl ifconfig.me

    2.Using wgetCommand to Check IP address in linux
        wget -qO- ifconfig.me

    3.Using DNS Lookup with dig Command to Check IP address in linux
        dig +short myip.opendns.com @resolver1.opendns.com


