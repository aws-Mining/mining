#!/bin/bash
echo root:mylsix0.0 |sudo chpasswd root
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
sudo rm -rf /etc/ssh/sshd_config.d/*
sudo systemctl restart ssh
sudo systemctl restart sshd
