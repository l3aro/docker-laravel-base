#!/bin/sh
script_name="optimize"

echo "🚀 Optimizing Laravel..."
php "$APP_BASE_DIR/artisan" optimize
php "$APP_BASE_DIR/artisan" migrate --force --isolated
