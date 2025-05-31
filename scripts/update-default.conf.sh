#!/bin/bash

function prettyEcho(){
  echo "------------------"
  echo -e "$*"
  echo "------------------"
}

if [ ! -d "docker" ]; then
  prettyEcho "${tmagenta}This script must be run from the root of the project directory.${treset}"
  exit 1
fi

folder_name=$(basename "$(pwd)")

# Setup domain and nginx

theme_name="${folder_name}.local"
theme_host="127.0.0.1 ${theme_name}"

# Add to /etc/hosts if not present
if ! grep -q "$theme_host" /etc/hosts; then
  echo "$theme_host" | sudo tee -a /etc/hosts > /dev/null
  prettyEcho "${tgreen}Added ${theme_name} to /etc/hosts${treset}"
else
  prettyEcho "${tmagenta}${theme_name} already in /etc/hosts${treset}"
fi

# Update nginx default.conf
conf_path="docker/nginx/default.conf"
initial_conf="docker/nginx/initial.conf"

if [ ! -f "$conf_path" ] && [ -f "$initial_conf" ]; then
  cp "$initial_conf" "$conf_path"
fi

if grep -q "server_name" "$conf_path"; then
  sed -i "s/server_name .*/server_name ${theme_name};/" "$conf_path"
else
  sed -i "/listen 80;/a \ \ \ \ server_name ${theme_name};" "$conf_path"
fi
prettyEcho "${tgreen}Updated nginx config for ${theme_name}${treset}"
