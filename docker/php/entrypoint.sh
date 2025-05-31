#!/bin/bash
set -e

chmod -R a+rwX /var/www/html/wp-content/ai1wm-backups
chmod -R a+rwX /var/www/html/wp-content/plugins/all-in-one-wp-migration/storage

exec "$@"
