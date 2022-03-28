#!/bin/sh

#!/bin/sh
set -e

echo "=== DB Init! ===";

gem install bundler --no-document
bundle install

echo "=== Done! ===";
