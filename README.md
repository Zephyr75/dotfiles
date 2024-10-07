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

In `/etc/pacman.conf`
```
Color
ILoveCandy
ParallelDownloads = 5
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

# Lockscreen

```sh
# Install lock screen
yay betterlockscreen

# Set wallpaper image
betterlockscreen -u <wallpaper_path>

# Lock the screen
betterlockscreen -l
```

# Customize appearance

- lxappearance
- papirus-icon-theme
- ttf-jetbrains-mono-nerd
- inter-font
- orchis-theme
- arc-icon-theme
- bibata-cursor-theme

# Browser

Package name is `zen-browser-bin`

Shortcuts:
- `Alt-j` for previous workspace
- `Alt-k` for next workspace

# Git

```bash
# Generate key
ssh-keygen -t ed25519 -C "<email>@gmail.com"

# Show key and add it to GitHub account
cat ~/.ssh/id_ed25519.pub
```

# Other packages to install

- rofi
- bluez
- network-manager-applet
- helix
- arandr
- brightnessctl
- libinput-gestures
- bat
- bat-extras
- fzf
- redshift
- tmux
- npm
- fastfetch
- vlc
- rxfetch
- xclip

# Utilities

npm install -g live-server
npm install -g md-to-pdf

# Config files

.zshrc` and `.tmux.conf` go in `/home/<user>`.
`bless-arc-dark.layout` goes in `/usr/share/bless/`.
All other config files and folders go to `/home/<user>/.config`.

# Use editor as default `xdg-open` application

Add `hx` as a browser on the list in /sbin/xdg-open
