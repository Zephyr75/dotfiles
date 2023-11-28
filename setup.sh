# Main dotfiles
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

rm -r ../ranger
cp -r ranger ..

rm -r ../rofi
cp -r rofi ..

# Bless
rm /usr/share/bless/bless-custom.layout
cp bless-custom.layout /usr/share/bless/

# .zshrc
cd ..
git clone git@github.com:Zephyr75/dotfiles_private.git
cp dotfiles_private/.zshrc ..
