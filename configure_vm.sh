#!/bin/bash

# This script configures a newly provisioned Ubuntu VM.

# Get the VM number from the command-line argument.
VM_NUMBER=$1

# Update the package lists and upgrade the installed packages.
sudo apt-get update
sudo apt-get upgrade -y

# Install Telegram.
sudo apt-get install -y telegram-desktop

# Install OpenVPN.
sudo apt-get install -y openvpn

# Install a VNC server.
sudo apt-get install -y x11vnc

# Set a password for the VNC server.
#
# **Important:** This will prompt you to enter a password for the VNC server.
x11vnc -storepasswd

# Calculate the VNC port number.
# The first VM will use port 5901, the second will use 5902, and so on.
VNC_PORT=$((5900 + $VM_NUMBER))

# Create a systemd service for the VNC server.
# This will ensure that the VNC server starts automatically on boot.
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

# Enable and start the VNC server.
sudo systemctl daemon-reload
sudo systemctl enable x11vnc.service
sudo systemctl start x11vnc.service

# Configure OpenVPN.
#
# **Important:** You must update this variable to the path of your .ovpn file.
OVPN_FILE="/path/to/your/config.ovpn"

# Check if the OpenVPN configuration file exists.
if [ -f "$OVPN_FILE" ]; then
    # Copy the OpenVPN configuration file to the correct location.
    sudo cp "$OVPN_FILE" /etc/openvpn/client.conf

    # Enable and start the OpenVPN client service.
    sudo systemctl enable openvpn@client
    sudo systemctl start openvpn@client

    echo "OpenVPN configured and started."
else
    # Inform the user that the OpenVPN configuration file was not found.
    echo "Warning: OpenVPN configuration file not found at $OVPN_FILE"
    echo "Please copy your .ovpn file to the VM and configure OpenVPN manually."
fi

# Inform the user that the configuration is complete.
echo "Configuration complete."
echo "You can now connect to this VM using a VNC client on port $VNC_PORT."
