########## Yay ##########

pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

########## Packages ########## 

pacman -S - < pkglist.txt

yay awesome-git

# picom
git clone https://github.com/jonaburg/picom
cd picom
meson --buildtype=release . build
ninja -C build

# AUR packages
yay bibata-cursor-theme
yay rxfetch
yay lightdm-webkit2-theme-glorious
yay orchis-theme
yay bluez

########## Utilities ##########

npm install -g live-server
npm install -g md-to-pdf
npx puppeteer browsers install chrome

########## .zshrc ##########

cd ..
git clone git@github.com:Zephyr75/dotfiles_private.git
