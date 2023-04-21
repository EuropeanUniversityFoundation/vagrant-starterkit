#!/usr/bin/env bash

# Preliminary steps.
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

# Install Apache2 web server for quick testing.
apt-get install apache2 -y
