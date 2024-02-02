#!/bin/bash

lvim_catpuccin="catppuccin-macchiato"
lvim_tokyonight="tokyonight-moon"
lvim_config="/home/zeph/.config/lvim/config.lua"

bat_catpuccin="Catppuccin-macchiato"
bat_tokyonight="Enki-Tokyo-Night"
zshrc_config="/home/zeph/.zshrc"

apple() {
  cd /home/zeph/.config/alacritty
  cp alacritty_white.toml alacritty.toml

  cd /home/zeph/.config/awesome
  cp rc_white.lua rc.lua

  sed -i "s/lvim.colorscheme = \"$lvim_tokyonight\"/lvim.colorscheme = \"$lvim_catpuccin\"/" "$lvim_config"
  sed -i "s/export BAT_THEME=\"$bat_tokyonight\"/export BAT_THEME=\"$bat_catpuccin\"/" "$zshrc_config"
}

coffee() {
  cd /home/zeph/.config/alacritty
  cp alacritty_colors.toml alacritty.toml

  cd /home/zeph/.config/awesome
  cp rc_colors.lua rc.lua

  sed -i "s/lvim.colorscheme = \"$lvim_catpuccin\"/lvim.colorscheme = \"$lvim_tokyonight\"/" "$lvim_config"
  sed -i "s/export BAT_THEME=\"$bat_catpuccin\"/export BAT_THEME=\"$bat_tokyonight\"/" "$zshrc_config"
}

themes=()
themes+=('apple')
themes+=('coffee')
selected_theme=$(echo "${themes[@]}" | tr ' ' '\n' | gum choose)

if [ "$selected_theme" == "apple" ]; then
  apple
elif [ "$selected_theme" == "coffee" ]; then
  coffee
fi

echo 'awesome.restart()' | awesome-client
