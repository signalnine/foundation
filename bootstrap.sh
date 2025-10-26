#!/usr/bin/env bash

###############################################################################
# Foundation Bootstrap
# Minimal script to get Foundation onto a fresh Mac
###############################################################################

set -e

FOUNDATION_REPO="signalnine/foundation"
FOUNDATION_DIR="$HOME/foundation"

echo ""
echo "Foundation Bootstrap"
echo "━━━━━━━━━━━━━━━━━━━━"
echo ""

# Install Xcode Command Line Tools (includes git)
if ! xcode-select -p &>/dev/null; then
    echo "→ Installing Xcode Command Line Tools..."
    echo "  (A dialog will appear - click Install and wait)"
    xcode-select --install

    # Wait for installation
    echo "  Waiting for installation to complete..."
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
    echo "✓ Xcode Command Line Tools installed"
else
    echo "✓ Xcode Command Line Tools already installed"
fi

# Clone the repository
if [ -d "$FOUNDATION_DIR" ]; then
    echo "✓ Foundation already cloned at $FOUNDATION_DIR"
    cd "$FOUNDATION_DIR"
    git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || true
else
    echo "→ Cloning Foundation repository..."
    echo ""
    echo "  You'll need to authenticate with GitHub."
    echo "  Options:"
    echo "    1. Use HTTPS (will prompt for GitHub credentials)"
    echo "    2. Use SSH (requires SSH key already in GitHub)"
    echo ""
    read -p "  Use SSH? (y/N): " use_ssh

    if [[ "$use_ssh" =~ ^[Yy]$ ]]; then
        git clone "git@github.com:$FOUNDATION_REPO.git" "$FOUNDATION_DIR"
    else
        git clone "https://github.com/$FOUNDATION_REPO.git" "$FOUNDATION_DIR"
    fi

    echo "✓ Foundation cloned"
    cd "$FOUNDATION_DIR"
fi

# Run the main setup
echo ""
echo "→ Starting Foundation setup..."
echo ""
chmod +x setup.sh
./setup.sh

echo ""
echo "✓ Bootstrap complete!"
