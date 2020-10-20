#!/bin/bash 
export DEBIAN_FRONTEND=noninteractive
apt -y update
apt -y upgrade
apt -y remove docker docker-engine docker.io
apt -y install docker.io
systemctl start docker
systemctl enable docker
mkdir -p /opt/html_content
cat << EOF > /opt/html_content/index.html
<!DOCTYPE html>
<html lang="en-US">
<head>
<title>Random DevOps Joke</title></head>
<body>
<script>
  var random = Math.floor(Math.random() * 5) +1;
  document.write('<img src="https://mydevopspublicbucket.s3.amazonaws.com/' + random +'.jpeg">'); 
</script>
EOF
echo "<br>Instance-ID: $(curl -s http://169.254.169.254/1.0/meta-data/instance-id)" >> /opt/html_content/index.html
echo "<br>LocalIP: $(curl -s http://169.254.169.254/1.0/meta-data/local-ipv4)" >> /opt/html_content/index.html
echo "</body>" >> /opt/html_content/index.html
docker run -v /opt/html_content:/usr/share/nginx/html:ro -p 8080:80 -d nginx
