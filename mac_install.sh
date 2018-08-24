#!/bin/bash

# OSX pre-reqs
sudo xcodebuild -license accept
xcode-select --install
/Applications/Xcode.app/Contents/MacOS/Xcode -installComponents # required by MacVim

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles YES

# set keyrepeat (Sierra/High Sierra)
defaults write NSGlobalDomain InitialKeyRepeat -int 20
defaults write NSGlobalDomain KeyRepeat -int 1

# Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor

# Various generic commandline utils
brew install wget

# Git and bash/git completion
brew install git bash-completion # Note, the OSX pre-installed Git will not work with bash-completion
git config --global user.name "Ryan Richardson"
git config --global user.email "ryananthonyrichardson@gmail.com"
source config/git.sh
echo -e "if [ -f `brew --prefix`/etc/bash_completion ]; then\n    . `brew --prefix`/etc/bash_completion\nfi" >> ~/.bash_profile

# git-aware bash prompt
brew install bash-git-prompt
echo -e "if [ -f \"$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh\" ]; then\n    source \"$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh\"\nfi" >> ~/.bash_profile

# MacVim & Fish Shell
brew install macvim --with-lua --HEAD
echo '/usr/local/bin/fish' | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
mkdir -p ~/.config/fish/functions
echo 'function vim' >> ~/.config/fish/functions/vim.fish
echo '  mvim -v $argv' >> ~/.config/fish/functions/vim.fish
echo 'end' >> ~/.config/fish/functions/vim.fish
echo 'function vi' >> ~/.config/fish/functions/vim.fish
echo '  mvim -v $argv' >> ~/.config/fish/functions/vim.fish
echo 'end' >> ~/.config/fish/functions/vim.fish
# package manager for Fish shell
curl -L https://get.oh-my.fish | fish



# Docker
brew install docker
brew install docker-compose
# "starter", tool to examine repo and bootstrap Dockerfile
curl -sSL https://raw.githubusercontent.com/cloud66/starter/master/install.sh | bash

# Allow writing to NTFS drives
# Example: sudo /usr/local/bin/ntfs-3g /dev/disk1s1 /Volumes/NTFS -olocal -oallow_other
# sub /dev/disk1s1 with your disk (find it with diskutil list)
brew cask install osxfuse
brew install homebrew/fuse/ntfs-3g
sudo mkdir /Volumes/NTFS

# Python
brew install pyenv
pyenv install 3.5.3
pyenv global 3.5.3
echo 'if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi' >> ~/.bashrc
source ~/.bashrc

# Ruby
echo "gem: --no-document" >> ~/.gemrc
curl -L https://get.rvm.io | bash -s stable --auto-dotfiles --autolibs=enable --rails
curl -L --create-dirs -o ~/.config/fish/functions/rvm.fish https://raw.github.com/lunks/fish-nuggets/master/functions/rvm.fish
echo "rvm default" >> ~/.config/fish/config.fish
source ~/.config/fish/config.fish
rvm install 2.5.1
rvm use 2.5.1 --default
gem install bundler

# Node Version Manager (via oh my fish)
omf install nvm
nvm install 10.6.0
nvm alias default v10.6.0

# Postrgresql Database (v10 as of Oct. 17)
brew install postgresql
brew services start postgresql
# echo "rm /usr/local/var/postgres/postmaster.pid" >> ~/.bashrc # fix the server running locally and accepting connections on Unix domain socket "/tmp/.s.PGSQL.5432" bullshit
# ^ need IF exists conditional here...

# Sublime Text 3
brew install caskroom/cask/brew-cask
brew tap caskroom/versions
brew cask install sublime-text

# JAVA and Android tools (basically, for adb)
brew cask install java7
brew cask install android-platform-tools

# Mission Pinball Framework
wget https://mpf.kantert.net/mpf_mac_frameworks.zip
unzip mpf_mac_frameworks.zip
sudo mv Frameworks/* /Library/Frameworks/
rm -Rf Frameworks
rm -Rf __MACOSX
rm -Rf ReadMe.txt
rm -Rf License.txt
rm -Rf mpf_mac_frameworks.zip
pip3 install pip setuptools cython==0.24.1 --upgrade
pip3 install mpf mpf-mc mpf-monitor

source ~/.bash_profile
