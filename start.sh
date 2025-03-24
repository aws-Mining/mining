#!/bin/bash

name=""
user=""

#
while getopts "n:u:" opt; do
  case $opt in
    n)
      name="$OPTARG"
      ;;
    u)
      user="$OPTARG"
      ;;
    *)
      echo "Usage: $0 -n <name> -u <user>"
      exit 1
      ;;
  esac
done

# 
if [[ -z "$name" ]]; then
  name=$(date +%s)
fi
if [[ -z "$user" ]]; then
  user='4AoMksz7Vb2daZLCrLdWQ3PE62J3XASk18q16axzss7ZgpEbkVdVoYZXyUjcuZ6kvZHh5uBEu3oaSLU6QtkwhxYQCPXmS8h'
fi

download_xmrig(){
  sudo wget -O /root/xmrig https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-linux-static-x64.tar.gz
  sudo mkdir /etc/xmrig
  sudo tar -xzvf /root/xmrig --strip-components=1 -C /etc/xmrig
  sudo rm /etc/xmrig/config.json
}

check_status(){
  SERVICE_NAME="xmrig.service"
  # 
  if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "$SERVICE_NAME is running"
  else
    systemctl restart xmrig
      # 
      # 
  fi
}
set_systemd(){
    sudo wget -O /etc/systemd/system/xmrig.service https://raw.githubusercontent.com/aws-Mining/mining/refs/heads/main/xmrig.service
    systemctl daemon-reload #
    sudo systemctl enable xmrig #
}

check_xmrig_file(){
  if [ -f "/etc/xmrig/xmrig" ]; then
    echo "File already exists"
  else
    download_xmrig
  fi
}

check_service_file(){
  if [ -f "/etc/systemd/system/xmrig.service" ]; then
    echo "File already exists"
  else
    set_systemd
  fi
}
set_config(){
  sudo rm /etc/xmrig/config.json
  sudo wget -O /etc/xmrig/config.json https://raw.githubusercontent.com/aws-Mining/mining/refs/heads/main/config.json
  jq --arg user "$user" --arg name "$name" '.pools[0].user = $user | .pools[0].pass = $name' /etc/xmrig/config.json > tmp.json && mv tmp.json /etc/xmrig/config.json
}
run(){
  check_xmrig_file
  check_service_file
  set_config
  check_status
}
run
