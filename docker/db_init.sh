#!/bin/sh
set -e

echo "=== DB Init! ===";

rake db:create
rake db:schema:load
rake db:seed

echo "=== Done! ===";