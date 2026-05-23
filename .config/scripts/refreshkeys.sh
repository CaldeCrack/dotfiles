sudo pacman -Sy archlinux-keyring
gpgconf --kill all
sudo pacman-key --populate archlinux
sudo pacman-key --refresh-key

