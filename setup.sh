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

########## .zshrc ##########

cd ..
git clone git@github.com:Zephyr75/dotfiles_private.git
cp dotfiles_private/.zshrc ..

########## Dotfiles ##########

rm -r ../awesome
cp -r awesome ..

rm -r ../alacritty
cp -r alacritty ..

rm -r ../feh
cp -r feh ..

rm -r ../lvim
cp -r lvim ..

rm -r ../picom
cp -r picom ..

rm -r ../rofi
cp -r rofi ..

rm /usr/share/bless/bless-custom.layout
sudo cp bless-custom.layout /usr/share/bless/

cp libinput-gestures.conf ..
