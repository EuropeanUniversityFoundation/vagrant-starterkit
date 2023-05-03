#!/usr/bin/env bash
# Snippet: Install Drush Launcher.
# https://github.com/drush-ops/drush-launcher#installation---phar
wget -qO drush.phar https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar
chmod +x drush.phar
mv drush.phar /usr/local/bin/drush
