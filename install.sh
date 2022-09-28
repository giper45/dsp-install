curl -s --compressed "https://dockersecurityplayground.github.io/ppa/KEY.gpg" | sudo apt-key add -
sudo curl -s --compressed -o /etc/apt/sources.list.d/dsp.list "https://dockersecurityplayground.github.io/ppa/dsp.list"
sudo apt update
sudo apt install -y dsp

