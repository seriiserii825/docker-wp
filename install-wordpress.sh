#!/bin/bash

set -e

cd /var/www

# Download latest WordPress if not already present
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

# Set proper permissions
# chown -R www-data:www-data /var/www
# Allow group write access and set group to your user
chown -R www-data:1000 /var/www
chmod -R g+rw /var/www
find /var/www -type d -exec chmod g+s {} \;
