# Start
sudo apt-get update

echo 'INSTALL curl'
sudo apt install curl -y

echo 'INSTALL snap'
sudo apt install snapd -y

echo 'INSTALL vim'
sudo apt install vim -y

# GIT configuration
echo 'INSTALL git'
sudo apt install git -y
clear

echo "What name do you use in GIT?"
echo "ex.: \"John Lennon\""
read git_config_user_name
git config --global user.name "$git_config_user_name"
clear

echo "What is your GIT email?"
read git_config_user_email
git config --global user.email $git_config_user_email
clear

echo "GIT user.name \"$git_config_user_name\" was defined"
echo "GIT user.email \"$git_config_user_email\" was defined"

echo "Do you want to set VIM as the default editor for GIT? (y/n)"
read git_default_editor
if echo "$git_default_editor" | grep -iq "^y" ;then
	git config --global core.editor vim
fi

echo "Generating a SSH Key..."
ssh-keygen -t rsa -b 4096 -C $git_config_user_email
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub

# Terminal configurations
echo 'INSTALL zsh'
sudo apt-get install zsh -y
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
chsh -s /bin/zsh

echo 'INSTALL autosuggestions' 
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
source ~/.zshrc

echo 'INSTALL theme'
sudo apt install fonts-firacode -y
wget -O ~/.oh-my-zsh/themes/node.zsh-theme https://raw.githubusercontent.com/skuridin/oh-my-zsh-node-theme/master/node.zsh-theme 
sed -i 's/.*ZSH_THEME=.*/ZSH_THEME="node"/g' ~/.zshrc

echo 'INSTALL terminator'
sudo apt-get update
sudo apt-get install terminator -y

# VsCode
echo 'INSTALL code'
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install code -y # or code-insiders

echo 'INSTALL extensions'
code --install-extension christian-kohler.path-intellisense
code --install-extension ashpowell.monokai-one-dark-vivid
code --install-extension foxundermoon.shell-format
code --install-extension waderyan.gitblame
code --install-extension yzhang.markdown-all-in-one
code --install-extension eamodio.gitlens

# Developer
echo 'INSTALL nvm' 
sh -c "$(curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash)"

export NVM_DIR="$HOME/.nvm" && (
git clone https://github.com/creationix/nvm.git "$NVM_DIR"
cd "$NVM_DIR"
git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

source ~/.zshrc
nvm --version
nvm install 12
nvm alias default 12
node --version
npm --version

echo 'INSTALL typescript'
npm install -g typescript

echo 'INSTALL nodemon'
npm install -g nodemon

echo 'INSTALL docker' 
sudo apt-get remove docker docker-engine docker.io
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
docker --version

chmod 777 /var/run/docker.sock

echo 'INSTALL docker-compose' 
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo 'INSTALL Kubernates'
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

echo 'INSTALL aws-cli' 
sudo apt-get install awscli -y
aws --version
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb
session-manager-plugin --version

# Tools
echo 'INSTALL slack' 
sudo snap install slack --classic

echo 'INSTALL chrome' 
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

echo 'INSTALL fzf'
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

echo 'INSTALL JetBrains datagrip'
sudo snap install datagrip --classic

echo 'INSTALL spotify' 
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client

echo 'finished'