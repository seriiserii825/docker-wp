#!/bin/bash -x

set -e

current_path=$(pwd)
current_dir=$(basename "$current_path")

cd /var/www/html


function downloadWordpress(){
  if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    curl -O https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    rm latest.tar.gz
    mv wordpress/* .
    rm -rf wordpress

    echo "Generating wp-config.php..."

    cat > wp-config.php <<EOF
  <?php
  define( 'DB_NAME', 'wordpress' );
  define( 'DB_USER', 'wp_user' );
  define( 'DB_PASSWORD', 'wp_pass' );
  define( 'DB_HOST', 'mysql' );
  define( 'DB_CHARSET', 'utf8mb4' );
  define( 'DB_COLLATE', '' );

  // Authentication Unique Keys and Salts
EOF

curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> wp-config.php

cat >> wp-config.php <<'EOF'

  $table_prefix = 'wp_';

  define( 'WP_DEBUG', false );

  if ( ! defined( 'ABSPATH' ) ) {
      define( 'ABSPATH', __DIR__ . '/' );
    }

  require_once ABSPATH . 'wp-settings.php';
EOF
echo "wp-config.php created."
else
  echo "WordPress already exists."
  fi
}

function setPermissions(){
  HOST_UID=${HOST_UID:-1000}
  HOST_GID=${HOST_GID:-1000}
  echo "Setting ownership to UID:${HOST_UID}, GID:${HOST_GID}..."
  chown -R ${HOST_UID}:${HOST_GID} /var/www/html
  chmod -R g+rw /var/www/html
  find /var/www/html -type d -exec chmod g+s {} \;
}


function installWP(){
  HOST_UID=$(id -u) HOST_GID=$(id -g) docker-compose run --rm wpcli core install \
    --url="http://localhost:80" \
    --title="My Site" \
    --admin_user=admin \
    --admin_password=admin \
    --admin_email=admin@gmail.com \
    --skip-email
}

# downloadWordpress
# setPermissions
# installWP
