#!/bin/bash
sudo apt install -y bat htop fd-find ranger
echo "alias cat='batcat'" >>.bashrc

# ranger config
ranger --copy-config=all
sed -i 's/set draw_borders none/set draw_borders both' ~/.config/ranger/rc.conf

# tldr installation
loc=/usr/local/bin/tldr # elevated privileges needed for some locations
sudo wget -qO $loc https://4e4.win/tldr
sudo chmod +x $loc

# lsd installation
curl -s https://api.github.com/repos/Peltoche/lsd/releases/latest |
    grep "browser_download_url.*lsd_.*amd64.deb" |
    cut -d : -f 2,3 |
    tr -d \" |
    wget -qi -
sudo dpkg -i lsd_*.deb
echo -e "alias ls='lsd'\nalias ll='ls -alF'\nalias la='ls -A'\nalias l='ls -CF'\nalias lst='lsd --tree'" >>.bashrc

# Nerd Font Install
curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest |
    grep "browser_download_url.*FiraCode.zip" |
    cut -d : -f 2,3 |
    tr -d \" |
    wget -qi -
unzip Hack.zip
sudo cp *.otf /usr/share/fonts/
fc-cache -fv

# Linuxbrew setup
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
source ~/.profile

# mcfly setup
brew tap cantino/mcfly
brew install mcfly
echo 'eval "$(mcfly init bash)"' >>.bashrc

# duf installation
brew install duf
