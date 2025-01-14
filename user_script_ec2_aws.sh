Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash
sudo -u ec2-user bash
cd /home/ec2-user
#/bin/echo "Hello World" >> ~/testfile.txt
sudo yum install -y python3 git pip virtualenv libX11 libXcomposite libXcursor libXdamage libXext libXi libXtst cups-libs libXScrnSaver libXrandr alsa-lib pango atk at-spi2-atk gtk3 libdrm libgbm nginx certbot python3-certbot-nginx sqlite java-17-amazon-corretto-devel.x86_64
# alias python to python3
echo "alias python='python3'" >> ~/.bashrc && source ~/.bashrc
# download selenium server
wget https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.17.0/selenium-server-4.17.0.jar
# download chrome for testing linux
wget https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/120.0.6099.109/linux64/chrome-linux64.zip
unzip chrome-linux64.zip
rm chrome-linux64.zip
echo "export PATH=\$PATH:$(pwd)/chrome-linux64" >> ~/.bashrc
# download chromedriver
wget https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/120.0.6099.109/linux64/chromedriver-linux64.zip
unzip chromedriver-linux64.zip
# add env variables
echo "export PATH=\$PATH:$(pwd)/chromedriver-linux64" >> ~/.bashrc
source ~/.bashrc
# Set your Git personal access token: AWS secrets
GIT_TOKEN="$(aws secretsmanager get-secret-value --secret-id GITHUB_TOKEN --output json | jq -r '.SecretString | fromjson | .GIT_TOKEN')"
# Set the repository URL
REPO_URL="https://$GIT_TOKEN@github.com/samidh93/AutoApplyApp.git"
# Clone the repository using the token
git clone "$REPO_URL"
# install dependencies
cd AutoApplyApp
./createVenv.sh
# run server
#./runFastApiServer.sh
#optional
echo "alias runFastapiServer='$(pwd)/runFastApiServer.sh'" >> ~/.bashrc
source ~/.bashrc
#return home
cd ..
# Set the repository URL
REPO_URL="https://$GIT_TOKEN@github.com/samidh93/AutoApplyDjangoBackend.git"
# Clone the repository using the token
git clone "$REPO_URL"
# install dependencies
cd AutoApplyDjangoBackend
./createVenv.sh
# run server
#./runDjangoServer.sh
#optional
echo "alias runDjangoServer='$(pwd)/runDjangoServer.sh'" >> ~/.bashrc
source ~/.bashrc
#return home
cd ..
# Set the repository URL
REPO_URL="https://$GIT_TOKEN@github.com/samidh93/easyAutoApplyAws.git"
# Clone the repository using the token
git clone "$REPO_URL"
cd easyAutoApplyAws
# configure gunicorn
sudo mkdir -pv /var/{log,run}/gunicorn/
sudo chown -cR $(whoami):$(whoami) /var/{log,run}/gunicorn/
# configure nginx 
echo 'alias GET="http --follow --timeout 6"' >> ~/.bashrc && source ~/.bashrc
# create directories if not there
sudo mkdir -pv /etc/nginx/sites-available/easyApplyWebServer/ 
sudo mkdir -v /etc/nginx/sites-enabled/
# copy from repo to 
sudo cp easyApplyWebServer.conf /etc/nginx/sites-available/easyApplyWebServer/
sudo cp nginx.conf /etc/nginx/nginx.conf
# simlink
sudo ln -s /etc/nginx/sites-available/easyApplyWebServer/ /etc/nginx/sites-enabled/
# copy certbot
sudo mkdir -pv /etc/letsencrypt/live/easyapply.xyz/
sudo cp -r certbot/* /etc/letsencrypt/live/easyapply.xyz/
sudo nginx -t
# change ownership root user
sudo chown -R ec2-user:ec2-user /home/ec2-user
# run selenium server hub
# hub: start on linux ec2
# java -jar selenium-server-4.17.0.jar hub 
# node: start on windows or mac
# java -jar selenium-server-4.17.0.jar node --hub http://172.31.32.169:4444
# java -jar selenium-server-4.17.0.jar node --host 149.233.44.36 --bind-host false
--//--