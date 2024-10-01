# Install Arch

```sh
# Connect to internet
iwctl
device list
device <device_name> scan
device <device_name> get-networks
device <device_name> connect <network_id>
exit

# Start archinstall
archinstall
```

- Same partition for `/home` and system
- NetworkManager wifi
- PipeWire audio

# Install Yay

```sh
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

# Install Zen

```sh
# Install firefox
yay firefox

# Download Zen as AppImage

# Copy Zen.desktop to /home/<user>/.local/share/applications

# Uninstall firefox
yay -Rns firefox
```

# Install Picom

```sh
git clone https://github.com/jonaburg/picom
cd picom
meson --buildtype=release . build
ninja -C build
sudo ninja -C build install
```

# Install Zsh

```sh
yay zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install autosuggestions and syntax highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Add plugins to .zshrc
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)
```

# Customize appearance

```sh
yay lxappearance
```

- papirus-icon-theme
- ttf-jetbrains-mono-nerd
- inter-font
- orchis-theme

# Other packages to install

- rofi
- network-manager-applet
- helix
- arandr
- brightnessctl

```sh
```sh
```sh
```sh
```sh
```sh
```sh
