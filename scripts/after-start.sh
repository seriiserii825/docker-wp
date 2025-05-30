#!/bin/bash -x

nginx_path="/var/www/html/docker/nginx/default.conf"

if [ ! -e "$nginx_path" ]; then
  echo "Nginx configuration file not found at $nginx_path"
  exit 1
fi

if grep -q "site_name" "$nginx_path"; then
  echo "site_name found in $nginx_path"
  grep "site_name" "$nginx_path"
else
  echo "site_name not found in $nginx_path"
fi
