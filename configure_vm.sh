#!/bin/bash

# Get the VM number from the command-line argument
VM_NUMBER=$1

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

# Calculate the VNC port
VNC_PORT=$((5900 + $VM_NUMBER))

# Create a systemd service for the VNC server
cat << EOF | sudo tee /etc/systemd/system/x11vnc.service
[Unit]
Description=x11vnc service
After=display-manager.service network.target syslog.target

[Service]
Type=simple
ExecStart=/usr/bin/x11vnc -forever -display :0 -auth guess -passwdfile /home/$(whoami)/.vnc/passwd -rfbport $VNC_PORT
ExecStop=/usr/bin/killall x11vnc
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the VNC server
sudo systemctl daemon-reload
sudo systemctl enable x11vnc.service
sudo systemctl start x11vnc.service

# Configure OpenVPN
OVPN_FILE="/path/to/your/config.ovpn"

if [ -f "$OVPN_FILE" ]; then
    sudo cp "$OVPN_FILE" /etc/openvpn/client.conf
    sudo systemctl enable openvpn@client
    sudo systemctl start openvpn@client
    echo "OpenVPN configured and started."
else
    echo "Warning: OpenVPN configuration file not found at $OVPN_FILE"
    echo "Please copy your .ovpn file to the VM and configure OpenVPN manually."
fi

echo "Configuration complete."
echo "You can now connect to this VM using a VNC client on port $VNC_PORT."
