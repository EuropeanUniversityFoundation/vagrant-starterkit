#!/usr/bin/env bash
# Snippet: Install MailHog.
# https://github.com/mailhog/MailHog#debian--ubuntu-go--v118
apt-get -y install golang-go
go get github.com/mailhog/MailHog
cp -p ~/go/bin/MailHog /usr/local/bin/mailhog

# https://gist.github.com/dipenparmar12/4e6cd50d8d1303d5e914742f62659116?permalink_comment_id=4485888#gistcomment-4485888
tee /etc/systemd/system/mailhog.service <<EOL
[Unit]
Description=Mailhog
After=network.target
[Service]
ExecStart=/usr/local/bin/mailhog \
  -api-bind-addr 127.0.0.1:8025 \
  -ui-bind-addr 127.0.0.1:8025 \
  -smtp-bind-addr 127.0.0.1:1025

[Install]
WantedBy=multi-user.target
EOL

service mailhog start
