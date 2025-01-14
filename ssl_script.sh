# tls and https
# setup ssl cert with certbot
# manual cert 
sudo certbot certonly --manual --preferred-challenges dns -d "*.easyapply.xyz"
# renew using nginx and updaste conf
sudo certbot -v --nginx -d *.easyapply.xyz
#
sudo cat /etc/nginx/nginx.conf
sudo nano /etc/nginx/nginx.conf
sudo rm /etc/nginx/nginx.conf
# sudo cp nginx.conf /etc/nginx/

sudo nginx -t -c /etc/nginx/nginx.conf
#
sudo cat /etc/nginx/sites-available/easyApplyWebServer/easyApplyWebServer.conf
sudo nano /etc/nginx/sites-available/easyApplyWebServer/easyApplyWebServer.conf
sudo rm /etc/nginx/sites-available/easyApplyWebServer/easyApplyWebServer.conf
# sudo cp easyApplyWebServer.conf /etc/nginx/sites-available/easyApplyWebServer/

# test config
sudo nginx -t -c /etc/nginx/sites-available/easyApplyWebServer/easyApplyWebServer.conf 

# sudo systemctl restart nginx
sudo systemctl reload nginx