# Run install script

```bash
./setup.sh
```

# Run update script

```bash
./update.sh
```

# ArchInstall

- Single partition for home and root
- Intall `dhcpcd`
- Choose `pulseaudio`

# Git

```bash
ssh-keygen -t ed25519 -C "<email>@gmail.com"

cat ~/.ssh/id_ed25519.pub
```

# Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

# Pacman

In `/etc/pacman.conf`
```bash
Color
ILoveCandy
ParallelDownloads = 5
 
[multilib]
Include = /etc/pacman.d/mirrorlist
```

# Npm

```bash
npm install -g live-server
```

# Firefox

![](img/2024-01-26-15-18-37.png)

# Qt

In `/etc/environment`
```
QT_QPA_PLATFORMTHEME=qt5ct
```

