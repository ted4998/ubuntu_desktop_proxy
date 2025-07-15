#!/bin/bash

# Update package lists
sudo apt-get update
sudo apt-get upgrade -y

# Install Telegram
sudo apt-get install -y telegram-desktop

# Install OpenVPN
sudo apt-get install -y openvpn

# Install a VNC server
sudo apt-get install -y x11vnc

# Set a password for the VNC server
x11vnc -storepasswd

# Create a systemd service for the VNC server
cat << EOF | sudo tee /etc/systemd/system/x11vnc.service
[Unit]
Description=x11vnc service
After=display-manager.service network.target syslog.target

[Service]
Type=simple
ExecStart=/usr/bin/x11vnc -forever -display :0 -auth guess -passwdfile /home/$(whoami)/.vnc/passwd
ExecStop=/usr/bin/killall x11vnc
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the VNC server
sudo systemctl daemon-reload
sudo systemctl enable x11vnc.service
sudo systemctl start x11vnc.service

echo "Configuration complete."
echo "You can now connect to this VM using a VNC client."
echo "You will need to manually configure OpenVPN with your .ovpn file."
