#!/usr/bin/env bash

###############################################################################
# Foundation Bootstrap
# Minimal script to get Foundation onto a fresh Mac
###############################################################################

set -e

FOUNDATION_REPO="signalnine/foundation"
FOUNDATION_DIR="$HOME/foundation"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

clear

printf "${CYAN}"
printf "
    ╔═══════════════════════════════════════════════════════╗
    ║                                                       ║
    ║              📦  FOUNDATION BOOTSTRAP  📦             ║
    ║                                                       ║
    ║         Getting Foundation onto a fresh Mac...        ║
    ║                                                       ║
    ╚═══════════════════════════════════════════════════════╝
"
printf "${NC}\n"
printf "${DIM}  \"To succeed, planning alone is insufficient.${NC}\n"
printf "${DIM}   One must improvise as well.\" - Hari Seldon${NC}\n\n"

# Install Xcode Command Line Tools (includes git)
if ! xcode-select -p &>/dev/null; then
    printf "${BLUE}→${NC} Installing Xcode Command Line Tools...\n"
    printf "${DIM}  (A dialog will appear - click Install and wait)${NC}\n"
    xcode-select --install

    # Wait for installation
    printf "${YELLOW}⟳${NC} Waiting for installation to complete...\n"
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
    printf "${GREEN}✓${NC} Xcode Command Line Tools installed\n"
else
    printf "${GREEN}✓${NC} Xcode Command Line Tools already installed\n"
fi

# Clone the repository
if [ -d "$FOUNDATION_DIR" ]; then
    printf "${GREEN}✓${NC} Foundation already cloned at ${BOLD}$FOUNDATION_DIR${NC}\n"
    cd "$FOUNDATION_DIR"
    git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || true
else
    printf "${BLUE}→${NC} Cloning Foundation repository...\n\n"
    printf "  ${CYAN}You'll need to authenticate with GitHub.${NC}\n"
    printf "  ${DIM}Options:${NC}\n"
    printf "    ${DIM}1. Use HTTPS (will prompt for GitHub credentials)${NC}\n"
    printf "    ${DIM}2. Use SSH (requires SSH key already in GitHub)${NC}\n\n"
    read -p "  Use SSH? (y/N): " use_ssh

    if [[ "$use_ssh" =~ ^[Yy]$ ]]; then
        git clone "git@github.com:$FOUNDATION_REPO.git" "$FOUNDATION_DIR"
    else
        git clone "https://github.com/$FOUNDATION_REPO.git" "$FOUNDATION_DIR"
    fi

    printf "${GREEN}✓${NC} Foundation cloned\n"
    cd "$FOUNDATION_DIR"
fi

# Run the main setup
printf "\n${BLUE}→${NC} Starting Foundation setup...\n\n"
chmod +x setup.sh
./setup.sh

printf "\n${GREEN}"
printf "╔═══════════════════════════════════════════════════════╗\n"
printf "║                                                       ║\n"
printf "║              ✓  BOOTSTRAP COMPLETE!  ✓                ║\n"
printf "║                                                       ║\n"
printf "╚═══════════════════════════════════════════════════════╝\n"
printf "${NC}\n"
