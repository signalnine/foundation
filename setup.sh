#!/usr/bin/env bash

###############################################################################
# Foundation
# A lightweight setup script for backend development on macOS
# "Violence is the last refuge of the incompetent." - Salvor Hardin
###############################################################################

set -e

# Check if output is to a terminal
if [ -t 1 ]; then
    INTERACTIVE=true
else
    INTERACTIVE=false
fi

# Colors and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'
DIM='\033[2m'

# Fun quotes from Foundation
QUOTES=(
    "Violence is the last refuge of the incompetent. - Salvor Hardin"
    "To succeed, planning alone is insufficient. One must improvise as well. - Hari Seldon"
    "Never let your sense of morals prevent you from doing what is right. - Salvor Hardin"
    "It pays to be obvious, especially if you have a reputation for subtlety. - Salvor Hardin"
    "The fall of Empire, gentlemen, is a massive thing, however, and not easily fought. - Hari Seldon"
)

# Get random quote
get_quote() {
    echo "${QUOTES[$RANDOM % ${#QUOTES[@]}]}"
}

# Helper functions
print_success() {
    printf "${GREEN}✓${NC} %s\n" "$1"
}

print_error() {
    printf "${RED}✗${NC} %s\n" "$1"
}

print_info() {
    printf "${BLUE}→${NC} %s\n" "$1"
}

print_warning() {
    printf "${YELLOW}!${NC} %s\n" "$1"
}

print_quote() {
    printf "${DIM}${CYAN}  \"%s\"${NC}\n" "$(get_quote)"
}

section() {
    printf "\n${BOLD}%s. %s${NC}\n" "$1" "$2"
    printf '%.0s─' {1..60}
    printf "\n"
}

# Spinner animation for long-running tasks
spinner() {
    local pid=$1
    local message=$2
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0

    printf "${BLUE}→${NC} %s " "$message"

    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %10 ))
        printf "\b${CYAN}%s${NC}" "${spin:$i:1}"
        sleep 0.1
    done

    printf "\b${GREEN}✓${NC}\n"
}

# Progress bar
progress_bar() {
    local current=$1
    local total=$2
    local width=40
    local percentage=$((current * 100 / total))
    local completed=$((width * current / total))
    local remaining=$((width - completed))

    printf "\r${BLUE}[${NC}"
    printf "${GREEN}%0.s█${NC}" $(seq 1 $completed)
    printf "${DIM}%0.s░${NC}" $(seq 1 $remaining)
    printf "${BLUE}]${NC} ${BOLD}%3d%%${NC}" $percentage

    if [ $current -eq $total ]; then
        printf " ${GREEN}✓${NC}\n"
    fi
}

# Fun loading animation
loading_animation() {
    local duration=$1
    local message=$2
    local frames=("🌑" "🌒" "🌓" "🌔" "🌕" "🌖" "🌗" "🌘")
    local end=$((SECONDS + duration))

    printf "${BLUE}→${NC} %s " "$message"

    while [ $SECONDS -lt $end ]; do
        for frame in "${frames[@]}"; do
            printf "\b\b%s " "$frame"
            sleep 0.1
            [ $SECONDS -ge $end ] && break
        done
    done

    printf "\b\b${GREEN}✓${NC} \n"
}

# Check for sudo access
ask_for_sudo() {
    print_info "Requesting sudo access..."
    sudo -v

    # Keep sudo alive
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    print_success "Sudo access granted"
}

# Install Xcode Command Line Tools
install_xcode_tools() {
    if xcode-select -p &>/dev/null; then
        print_success "Xcode Command Line Tools already installed"
    else
        print_info "Installing Xcode Command Line Tools..."
        xcode-select --install

        # Wait for installation to complete
        until xcode-select -p &>/dev/null; do
            sleep 5
        done

        print_success "Xcode Command Line Tools installed"
    fi
}

# Install Homebrew
install_homebrew() {
    if command -v brew &>/dev/null; then
        print_success "Homebrew already installed"
    else
        print_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for Apple Silicon
        if [[ $(uname -m) == 'arm64' ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi

        print_success "Homebrew installed"
    fi
}

# Install Homebrew packages
install_brew_packages() {
    local packages=(
        git
        gh              # GitHub CLI
        wget
        curl
        jq              # JSON processor
        htop            # System monitor
        tree            # Directory viewer
        tldr            # Simplified man pages (tldr client)
        ripgrep         # Fast grep alternative
        fd              # Fast find alternative
        bat             # Better cat
        eza             # Better ls
        fzf             # Fuzzy finder
        tmux            # Terminal multiplexer
        node            # Node.js
        python@3.12     # Python
        go              # Go language
        postgresql@16   # PostgreSQL
        redis           # Redis
        docker          # Docker CLI
        awscli          # AWS CLI
    )

    local total=${#packages[@]}
    local current=0

    printf "\n${CYAN}Installing ${BOLD}%d${NC}${CYAN} development tools...${NC}\n\n" "$total"

    for package in "${packages[@]}"; do
        current=$((current + 1))
        local package_name="${package%%@*}"

        if brew list --formula | grep -q "^${package_name}$"; then
            printf "  ${DIM}[%2d/%d]${NC} ${GREEN}✓${NC} %s ${DIM}(already installed)${NC}\n" "$current" "$total" "$package"
        else
            printf "  ${DIM}[%2d/%d]${NC} ${YELLOW}↻${NC} Installing %s..." "$current" "$total" "$package"
            if brew install "$package" >/dev/null 2>&1; then
                printf "\r  ${DIM}[%2d/%d]${NC} ${GREEN}✓${NC} %s installed              \n" "$current" "$total" "$package"
            else
                printf "\r  ${DIM}[%2d/%d]${NC} ${RED}✗${NC} %s ${RED}(failed)${NC}              \n" "$current" "$total" "$package"
            fi
        fi

        progress_bar "$current" "$total"
    done

    printf "\n"
}

# Install applications via Homebrew Cask
install_applications() {
    local apps=(
        iterm2
        visual-studio-code
        docker
        rectangle           # Window management (free alternative to Divvy)
        1password
        slack
        arc                # Modern browser
    )

    local total=${#apps[@]}
    local current=0

    printf "\n${CYAN}Installing ${BOLD}%d${NC}${CYAN} applications...${NC}\n\n" "$total"

    for app in "${apps[@]}"; do
        current=$((current + 1))

        if brew list --cask | grep -q "^${app}$"; then
            printf "  ${DIM}[%2d/%d]${NC} ${GREEN}✓${NC} %s ${DIM}(already installed)${NC}\n" "$current" "$total" "$app"
        else
            printf "  ${DIM}[%2d/%d]${NC} ${YELLOW}↻${NC} Installing %s..." "$current" "$total" "$app"
            if brew install --cask "$app" >/dev/null 2>&1; then
                printf "\r  ${DIM}[%2d/%d]${NC} ${GREEN}✓${NC} %s installed              \n" "$current" "$total" "$app"
            else
                printf "\r  ${DIM}[%2d/%d]${NC} ${RED}✗${NC} %s ${RED}(failed)${NC}              \n" "$current" "$total" "$app"
            fi
        fi

        progress_bar "$current" "$total"
    done

    printf "\n"
}

# Setup SSH keys from GitHub
setup_ssh_keys() {
    if [ -f "$HOME/.ssh/id_ed25519.pub" ] || [ -f "$HOME/.ssh/id_rsa.pub" ]; then
        print_success "SSH key already exists"

        # Add to authorized_keys
        if [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
            cat "$HOME/.ssh/id_ed25519.pub" >> "$HOME/.ssh/authorized_keys" 2>/dev/null || true
        elif [ -f "$HOME/.ssh/id_rsa.pub" ]; then
            cat "$HOME/.ssh/id_rsa.pub" >> "$HOME/.ssh/authorized_keys" 2>/dev/null || true
        fi

        print_info "To import SSH keys from GitHub, run:"
        print_info "  curl https://github.com/signalnine.keys >> ~/.ssh/authorized_keys"
    else
        print_info "Generating new SSH key..."
        read -p "Enter your email address: " email
        ssh-keygen -t ed25519 -C "$email" -f "$HOME/.ssh/id_ed25519" -N ""

        # Start ssh-agent and add key
        eval "$(ssh-agent -s)"
        ssh-add "$HOME/.ssh/id_ed25519"

        # Copy to clipboard
        pbcopy < "$HOME/.ssh/id_ed25519.pub"

        print_success "SSH key generated and copied to clipboard"
        print_info "Add it to GitHub: https://github.com/settings/keys"
    fi
}

# Configure macOS settings
configure_macos() {
    print_info "Configuring macOS settings..."

    # Enable dark mode
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true' 2>/dev/null || \
        defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
    print_success "Dark mode enabled"

    # Set fast key repeat
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15
    print_success "Fast key repeat configured"

    # Reverse scroll direction (disable "natural" scrolling)
    # Note: Requires logout/login to take effect
    defaults write -g com.apple.swipescrolldirection -bool false
    print_success "Traditional scroll direction enabled (requires logout)"

    # Show hidden files in Finder
    defaults write com.apple.finder AppleShowAllFiles -bool true
    print_success "Show hidden files enabled"

    # Show path bar in Finder
    defaults write com.apple.finder ShowPathbar -bool true
    print_success "Finder path bar enabled"

    # Disable "Are you sure you want to open?" dialog
    defaults write com.apple.LaunchServices LSQuarantine -bool false
    print_success "Disabled app quarantine dialog"

    # Restart Finder to apply changes
    killall Finder 2>/dev/null || true

    print_success "macOS configuration complete"
}

# Install Claude Code
install_claude_code() {
    if command -v claude &>/dev/null; then
        print_success "Claude Code already installed"
    else
        print_info "Installing Claude Code..."

        # Install via npm
        if command -v npm &>/dev/null; then
            npm install -g @anthropic-ai/claude-code
            print_success "Claude Code installed"
        else
            print_warning "npm not found, skipping Claude Code installation"
            print_info "Install Node.js first, then run: npm install -g @anthropic-ai/claude-code"
        fi
    fi
}

# Setup Git configuration
setup_git() {
    if [ -z "$(git config --global user.name)" ]; then
        print_info "Configuring Git..."
        read -p "Enter your name: " name
        read -p "Enter your email: " email

        git config --global user.name "$name"
        git config --global user.email "$email"
        git config --global init.defaultBranch main
        git config --global pull.rebase false

        print_success "Git configured"
    else
        print_success "Git already configured"
    fi
}

# Main installation flow
main() {
    # Clear screen (works better with tee than 'clear' command)
    printf '\033[2J\033[H'

    # Animated title screen
    printf "${CYAN}"
    printf "
    ███████╗ ██████╗ ██╗   ██╗███╗   ██╗██████╗  █████╗ ████████╗██╗ ██████╗ ███╗   ██╗
    ██╔════╝██╔═══██╗██║   ██║████╗  ██║██╔══██╗██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║
    █████╗  ██║   ██║██║   ██║██╔██╗ ██║██║  ██║███████║   ██║   ██║██║   ██║██╔██╗ ██║
    ██╔══╝  ██║   ██║██║   ██║██║╚██╗██║██║  ██║██╔══██║   ██║   ██║██║   ██║██║╚██╗██║
    ██║     ╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║
    ╚═╝      ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
    ${NC}"
    printf "\n${BOLD}                        macOS Setup for Backend Development${NC}\n"
    printf "${DIM}                        Estimated time: ~15 minutes${NC}\n\n"
    print_quote
    printf "\n"

    sleep 1

    section "1" "System Prerequisites"
    ask_for_sudo
    install_xcode_tools
    print_quote

    section "2" "Package Manager"
    install_homebrew
    print_quote

    section "3" "Development Tools"
    install_brew_packages
    print_quote

    section "4" "Applications"
    install_applications
    print_quote

    section "5" "SSH Configuration"
    setup_ssh_keys

    section "6" "Git Configuration"
    setup_git

    section "7" "macOS Settings"
    configure_macos
    print_quote

    section "8" "Claude Code"
    install_claude_code

    # Final celebration
    printf "\n\n"
    printf "${GREEN}"
    printf "    ╔═══════════════════════════════════════════════════════════╗\n"
    printf "    ║                                                           ║\n"
    printf "    ║              🎉  SETUP COMPLETE!  🎉                      ║\n"
    printf "    ║                                                           ║\n"
    printf "    ║  Your Foundation is ready for the coming dark age...     ║\n"
    printf "    ║                                                           ║\n"
    printf "    ╚═══════════════════════════════════════════════════════════╝\n"
    printf "${NC}\n"

    print_info "Restart your terminal for all changes to take effect."
    print_warning "Log out and back in for scroll direction changes to apply."

    printf "\n${DIM}${CYAN}"
    printf "  \"Never let your sense of morals prevent you from doing what is right.\"\n"
    printf "                                        - Salvor Hardin\n"
    printf "${NC}\n"
}

# Run main function
# Note: Logging is handled by redirection if needed
# To log output: ./setup.sh 2>&1 | tee foundation.log
main
