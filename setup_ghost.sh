sudo apt-get update && sudo apt-get upgrade
echo "Installing NGINX and MYSQL"
sudo apt-get install nginx mysql-server
sudo ufw allow 'Nginx Full'

echo "Installing Nodejs"
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash
sudo apt-get install -y nodejs

echo "Installing Ghost CLI"
sudo npm install ghost-cli@latest -g


# We'll name ours 'ghost' in this example; you can use whatever you want
sudo mkdir -p /var/www/ghost
# Replace <user> with the name of your user who will own this directory
sudo chown `whoami`:`whoami` /var/www/ghost
# Set the correct permissions
sudo chmod 775 /var/www/ghost
# Then navigate into it
cd /var/www/ghost && ghost install
echo "Ghost installed successfully"