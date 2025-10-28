# Foundation

> "To succeed, planning alone is insufficient. One must improvise as well." - Hari Seldon

A lightweight, mathematically precise setup script for macOS focused on backend development. Like Hari Seldon's plan to preserve knowledge through the coming dark age, Foundation establishes the tools needed to build the future.

Designed to work efficiently on machines with limited storage (256GB+).

## What it installs

### Development Tools
- **Git** - Version control
- **GitHub CLI** - GitHub from the command line
- **Node.js** - JavaScript runtime
- **Python 3.12** - Latest Python
- **Go** - Go programming language
- **PostgreSQL 16** - Database
- **Redis** - In-memory data store
- **Docker** - Containerization

### CLI Utilities
- **ripgrep** - Fast grep alternative
- **fd** - Fast find alternative
- **bat** - Better cat with syntax highlighting
- **eza** - Better ls with icons
- **fzf** - Fuzzy finder
- **jq** - JSON processor
- **htop** - System monitor
- **tmux** - Terminal multiplexer
- **tree** - Directory viewer
- **tlrc** - Simplified man pages (fast tldr client)

### Applications
- **iTerm2** - Better terminal
- **Visual Studio Code** - Code editor
- **Docker Desktop** - Docker GUI
- **Rectangle** - Window management
- **1Password** - Password manager
- **Slack** - Communication
- **Arc** - Modern browser
- **Claude Code** - AI coding assistant

### macOS Configuration
- Dark mode enabled
- Fast key repeat (2ms repeat, 15ms initial delay)
- Traditional scroll direction (disable "natural" scrolling) - *requires logout*
- Show hidden files in Finder
- Show path bar in Finder
- Disable app quarantine dialogs

**Note**: Some settings (especially scroll direction) require logging out and back in to take effect.

## Quick Start (Brand New Mac)

On a fresh Mac, run this one-liner:

```bash
curl -fsSL https://raw.githubusercontent.com/signalnine/foundation/main/bootstrap.sh | bash
```

This installs Xcode Command Line Tools, clones the repo, and runs the full setup.

**OR** see [BOOTSTRAP.md](BOOTSTRAP.md) for alternative installation methods.

## Installation (If You Already Have Git)

1. Clone this repository:
```bash
git clone https://github.com/signalnine/foundation.git
cd foundation
```

2. Review the script:
```bash
cat setup.sh
```

3. Run the setup:
```bash
chmod +x setup.sh
./setup.sh
```

The script will guide you through:
1. System Prerequisites
2. Package Manager (Homebrew)
3. Development Tools
4. Applications
5. SSH Configuration
6. Git Configuration
7. macOS Settings
8. Claude Code

Should take approximately 15 minutes. All output is logged to `~/foundation.log` for reference.

## Customization

Edit `setup.sh` to customize the packages and applications installed. The main arrays to modify are:

- `packages` - Homebrew formulae (line ~60)
- `apps` - Homebrew casks (line ~105)

## SSH Keys

The script can either:
1. Use existing SSH keys if found
2. Generate new ED25519 SSH keys

To import your existing SSH keys from GitHub:
```bash
curl https://github.com/signalnine.keys >> ~/.ssh/authorized_keys
```

## Storage Considerations

This setup is designed to be lightweight (~10-15GB including applications). For a 256GB Mac:
- Base install: ~5GB
- Applications: ~5-10GB
- Docker images: varies (use `docker system prune` regularly)

## Post-Installation

After running the setup:

1. Restart your terminal to ensure all PATH changes take effect
2. Configure iTerm2 preferences (colors, fonts, etc.)
3. Setup VS Code settings sync if desired
4. Login to applications (1Password, Slack, etc.)
5. Import GitHub SSH keys if needed

## Maintenance

Re-run the script anytime to update packages:
```bash
./setup.sh
```

The script is idempotent - it safely skips already installed items.

## License

MIT
