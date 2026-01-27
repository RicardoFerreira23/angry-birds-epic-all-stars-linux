<p align="center">
  <img src="assets/background.jpg" width="100%" alt="Angry Birds Epic Banner">
</p>

<h1 align="center">🐦 Angry Birds Epic: All Stars Linux Launcher</h1>

<p align="center">
  <a href="https://github.com/seu-usuario/seu-repositorio/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="MIT License">
  </a>
  <img src="https://img.shields.io/badge/Platform-Linux-orange?style=for-the-badge&logo=linux" alt="Linux">
  <img src="https://img.shields.io/badge/Wine-Tested-blue?style=for-the-badge&logo=winehq" alt="Wine">
</p>

<p align="center">
  <strong>A lightweight, automated, and simplified bash-based launcher to run Angry Birds Epic: All Stars on Linux.</strong>
</p>

---

## ✨ Features

* **⚡ One-Time Setup:** Select your game folder once, and the launcher handles the file migration.
* **🌍 Auto-Translation:** Automatically forces the game language to **Portuguese (Brazil)** via Wine registry injection.
* **📦 Isolated Prefix:** Keeps all game data and Wine configurations separate from your system in `~/.abe_allstars`.
* **🛠️ Mod Compatibility:** Pre-configured with essential DLL overrides (`winhttp`) required for the All Stars mod.
* **📜 Debugging Logs:** Generates detailed logs for both installation (`install_log.txt`) and runtime (`wine_log.txt`).

## 📋 Prerequisites

This launcher depends on a few native tools to ensure a seamless experience:
* **Wine** (Stable, Staging, or GE-Proton)
* **Zenity** (For the graphical user interface)

```bash
# How to install dependencies:

# Ubuntu / Debian / Mint
sudo apt install wine zenity

# Arch Linux
sudo pacman -S wine zenity

# Fedora
sudo dnf install wine zenity
🚀 How to Use
Clone the repository:

Bash
git clone [https://github.com/your-username/your-repo-name.git](https://github.com/your-username/your-repo-name.git)
cd your-repo-name
Grant execution permission:

Bash
chmod +x launcher/run.sh
Launch the game:

Bash
./launcher/run.sh
Note: On the first run, a window will pop up asking you to select the folder containing the original Windows game files.

📂 Folder Structure
Once installed, the launcher manages everything within the following directory:

~/.abe_allstars/ - Main directory containing game files and the Wine prefix.

~/.abe_allstars/install_log.txt - History of the installation process.

~/.abe_allstars/wine_log.txt - Real-time logs for troubleshooting game crashes or errors.
```
<p align="center"> Based on the <strong>Angry Birds Epic: All Stars</strong> community project.Built with simplicity and performance in mind for the Linux community.</p>


-----
