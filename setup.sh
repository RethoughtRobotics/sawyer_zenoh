#!/usr/bin/env bash
# Run once: bash setup.sh

set -eo pipefail

REPO_DIR="$(dc "$(dirname "$0")" && pwd)"

[[ "$SHELL" == */zsh ]] && SHELL_RC="$HOME/.zshrc" || SHELL_RC="$HOME/.bashrc"

# Check for nmcli
if ! command -v nmcli &>/dev/null; then
    echo "ERROR: nmcli not found. Install NetworkManager first:" >&2
    echo "  sudo apt-get install network-manager" >&2
    exit 1
fi

# Install the Ethernet connection profile
echo "[1/4] Installing Rethink Ethernet profile..."
sudo cp "$REPO_DIR/Rethink.nmconnection" /etc/NetworkManager/system-connections/Rethink.nmconnection
sudo chown root:root /etc/NetworkManager/system-connections/Rethink.nmconnection
sudo chmod 600 /etc/NetworkManager/system-connections/Rethink.nmconnection
sudo systemctl restart NetworkManager
echo "      Ethernet profile installed."

# Add robot hostname
echo "[2/4] Adding sawyer.local to /etc/hosts..."
if grep -qF "sawyer.local" /etc/hosts; then
    echo "      Already present — skipping."
else
    echo "10.42.0.2 sawyer.local" | sudo tee -a /etc/hosts > /dev/null
    echo "      Done."
fi

# Install Zenoh ROS 2 middleware
ZENOH_PKG="ros-${ROS_DISTRO:?ROS_DISTRO is not set - source your ROS 2 setup first}-rmw-zenoh-cpp"
echo "[3/4] Installing Zenoh ROS 2 middleware ($ZENOH_PKG)..."
if dpkg -s "$ZENOH_PKG" &>/dev/null; then
    echo "      Already installed — skipping."
else
    sudo apt-get install -y -q "$ZENOH_PKG" 2>&1 | grep -v "^$" | grep -v "autoremove" | grep -v "automatically installed"
    echo "      Zenoh installed."
fi

# Append aliases to $SHELL_RC
echo "[4/4] Configuring $SHELL_RC..."
if ! grep -qF "# Sawyer Bridge" $SHELL_RC; then
    cat >> $SHELL_RC <<EOF

# Sawyer Bridge
alias sawyer_start='bash $REPO_DIR/connect.sh'
alias sawyer_msgs='source $REPO_DIR/activate.sh'
EOF
    echo "      Added sawyer_start and sawyer_msgs aliases."
else
    echo "      Already configured — skipping."
fi

echo ""
echo "Setup complete. Run: source $SHELL_RC"
