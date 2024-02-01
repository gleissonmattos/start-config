#!/bin/bash

# Start
sudo apt-get update

echo 'INSTALL curl'
sudo apt install curl -y

echo 'INSTALL snap'
sudo apt install snapd -y

echo 'INSTALL brew'
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/:$PATH"' >>~/.bashrc
echo 'export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"' >>~/.bashrc
echo 'export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"' >>~/.bashrc
source  ~/.bashrc
brew --version

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

echo -e "\nYour SSH Key has been generated successfully."
echo "Now, you need to add the SSH key to your remote services."
echo "1. Copy the SSH key below:"
echo "----------------------------------------"
cat ~/.ssh/id_rsa.pub
echo "----------------------------------------"
echo "2. Visit the SSH key settings on your remote service:"
echo "   - For GitHub: https://github.com/settings/keys"
echo "   - For GitLab: https://gitlab.com/-/profile/keys"
echo "   - For Bitbucket: https://bitbucket.org/account/settings/ssh-keys/"
echo "3. Add a new SSH key and paste the copied key."
echo "4. Once added, press ENTER to continue with the rest of the setup."

read -p "Press ENTER to continue..."

# Terminal configurations
echo 'INSTALL zsh'
sudo apt-get install zsh -y
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

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
code --install-extension vscode-icons-team.vscode-icons
code --install-extension coenraads.bracket-pair-colorizer-2

# Developer
echo 'INSTALL nvm' 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

source ~/.zshrc
nvm --version
nvm install v20.11.0
nvm alias default v20.11.0
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

echo 'INSTALL helm'
sudo snap install helm --classic

echo 'INSTALL aws-cli' 
sudo apt-get install awscli -y
aws --version
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb
session-manager-plugin --version

install_insomnia() {
    echo 'Installing Insomnia...'
    sudo snap install insomnia
    echo 'Insomnia installed successfully!'
}

install_postman() {
    echo 'Installing Postman...'
    sudo snap install postman
    echo 'Postman installed successfully!'
}

select_api_tool() {
    PS3="Select API testing tool to install (type the corresponding number and press Enter): "
    options=("Insomnia" "Postman" "Install manually later")

    select choice in "${options[@]}"; do
        case $REPLY in
            1) install_insomnia; break ;;
            2) install_postman; break ;;
            3) echo 'You chose to install manually later.'; break ;;
            *) echo 'Invalid option. Please try again.' ;;
        esac
    done
}

select_api_tool

install_vpn_client() {
    echo 'Installing Pritunl...'

    sudo tee /etc/apt/sources.list.d/pritunl.list <<EOF
    deb https://repo.pritunl.com/stable/apt jammy main
EOF

    sudo apt --assume-yes install gnupg
    gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
    gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A | sudo tee /etc/apt/trusted.gpg.d/pritunl.asc
    sudo apt update
    sudo apt install pritunl-client-electron

    echo 'Pritunl installed successfully!'
}

install_vpn_client

# Tools
echo 'INSTALL slack' 
sudo snap install slack --classic

echo 'INSTALL chrome' 
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

echo 'INSTALL fzf'
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

install_datagrip() {
    echo 'Installing JetBrains Datagrip...'
    sudo snap install datagrip --classic
    echo 'Datagrip installed successfully!'
}

install_dbeaver() {
    echo 'Installing DBeaver...'
    sudo snap install dbeaver-ce
    echo 'DBeaver installed successfully!'
}

select_database_client() {
    PS3="Select a database client to install (type the corresponding number and press Enter): "
    options=("JetBrains Datagrip" "DBeaver" "Install manually later")

    select choice in "${options[@]}"; do
        case $REPLY in
            1) install_datagrip; break ;;
            2) install_dbeaver; break ;;
            3) echo 'You chose to install manually later.'; break ;;
            *) echo 'Invalid option. Please try again.' ;;
        esac
    done
}

select_database_client

echo 'INSTALL spotify' 
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client

echo 'finished'

chsh -s /bin/zsh