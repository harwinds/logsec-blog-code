#! /bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo BEGIN
sudo apt-get update
sudo apt-get upgrade -y
cd /tmp && wget -O splunk-8.0.3-a6754d8441bf-linux-2.6-amd64.deb 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=8.0.3&product=splunk&filename=splunk-8.0.3-a6754d8441bf-linux-2.6-amd64.deb&wget=true'
cd /opt
sudo dpkg -i /tmp/splunk-8.0.3-a6754d8441bf-linux-2.6-amd64.deb
cd splunk/
/opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --gen-and-print-passwd
echo END