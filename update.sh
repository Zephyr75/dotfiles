########## Dotfiles ##########
rm -r ../awesome
cp -r awesome ..

rm -r ../alacritty
cp -r alacritty ..

rm -r ../lvim
cp -r lvim ..

rm -r ../picom
cp -r picom ..

rm -r ../rofi
cp -r rofi ..

rm /usr/share/bless/bless-custom.layout
sudo cp bless-custom.layout /usr/share/bless/

cp libinput-gestures.conf ..

cd ..
cp dotfiles_private/.zshrc ..
