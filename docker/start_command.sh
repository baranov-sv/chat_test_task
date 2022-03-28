#!/bin/sh

set -e

echo "=== Bundle... ==="
bundle install
echo "=== Migration DB... ==="
rake db:migrate
echo "=== Starting application... ==="
rails s -b 0.0.0.0
