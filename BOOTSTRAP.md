# Bootstrap Guide

Getting Foundation onto a brand new Mac.

## The Problem

Fresh Mac challenges:
- No git installed yet
- Can't clone repos
- Basic Terminal only
- Need to authenticate with GitHub

## The Solution

Three methods, from easiest to most control:

---

## Method 1: One-Line Bootstrap (Easiest)

Once you've pushed this to GitHub, you can bootstrap with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/signalnine/foundation/main/bootstrap.sh | bash
```

**What this does:**
1. Downloads the bootstrap script
2. Installs Xcode Command Line Tools (includes git)
3. Clones the Foundation repo
4. Runs the full setup

**Pros:** One command, very fast
**Cons:** Running remote scripts (though you wrote it!)

---

## Method 2: Manual Download (Most Control)

1. **Download without git:**
   - Go to: `https://github.com/signalnine/foundation`
   - Click the green "Code" button
   - Select "Download ZIP"
   - Unzip in Downloads folder

2. **Run setup:**
   ```bash
   cd ~/Downloads/foundation-main
   chmod +x setup.sh
   ./setup.sh
   ```

**Pros:** Full visibility, no remote execution
**Cons:** More clicks, manual download

---

## Method 3: Bootstrap Script Locally (Good Middle Ground)

1. **Install Xcode Command Line Tools first:**
   ```bash
   xcode-select --install
   ```
   Wait for the dialog to complete (~5 minutes)

2. **Clone Foundation:**
   ```bash
   git clone https://github.com/signalnine/foundation.git
   cd foundation
   ```
   (You'll be prompted for GitHub credentials)

3. **Run setup:**
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

**Pros:** Step-by-step control
**Cons:** Manual steps

---

## First-Time GitHub Authentication

### HTTPS (Simpler)
When you clone via HTTPS, you'll need:
- GitHub username
- Personal Access Token (not your password!)

Create a token at: https://github.com/settings/tokens
- Click "Generate new token (classic)"
- Select: `repo` scope
- Copy the token and use it as your password

### SSH (Better for long-term)
If you already have SSH keys configured with GitHub, use:
```bash
git clone git@github.com:signalnine/foundation.git
```

Otherwise, wait for the setup script to generate keys for you.

---

## Recommended Flow for Brand New Mac

1. Open Terminal (Cmd+Space, type "Terminal")

2. Run the one-liner:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/signalnine/foundation/main/bootstrap.sh | bash
   ```

3. **Click "Install" when the Xcode dialog appears** (this is required)

4. Wait for Xcode Command Line Tools to install (~2-5 minutes)

5. Enter your sudo password when prompted

6. When prompted for GitHub, choose HTTPS (unless you already have SSH keys)

7. Enter your GitHub credentials when asked

8. Let it run (~15 minutes total)

9. Restart Terminal when complete

Done!

### Important Notes

- **GUI Required**: The Xcode installation dialog requires clicking "Install" - this cannot be automated
- **Interactive Session Required**: You'll need to enter your sudo password, so this must run in an interactive terminal
- **Remote Installation**: If you're setting up via SSH, you'll need physical access to click the Xcode dialog and may need to run the script locally on the machine

---

## Troubleshooting

**"curl: command not found"**
This shouldn't happen on macOS - curl is built-in. Try restarting Terminal.

**"xcode-select: error: command line tools are already installed"**
Good! Skip to cloning the repo.

**Xcode dialog doesn't appear**
Try running manually: `xcode-select --install`

**"Need sudo access"** or **"a password is required"**
This is normal. Enter your macOS user password when prompted. The script needs admin privileges to install system tools.

**GitHub authentication fails**
- For HTTPS: Make sure you're using a Personal Access Token, not your password
- For SSH: You'll need to set up keys first (or use HTTPS for now)

**Script fails partway through**
Check `~/foundation.log` for errors. The script is idempotent - you can safely re-run it.

**Running over SSH**
If you're setting up a remote Mac:
1. SSH into the machine: `ssh your-mac.local`
2. You'll need to be at the physical machine to click the Xcode install dialog
3. Run the setup in your SSH session - it will prompt for your password
4. Alternatively, use Screen Sharing and run the script in Terminal directly
