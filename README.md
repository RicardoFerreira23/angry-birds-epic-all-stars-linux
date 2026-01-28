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

* **⚡ One-Time Setup:** Select your game folder once, and the launcher handles the file migration automatically.
* **🖥️ Native Integration:** Automatically creates a Desktop Entry (`.desktop`) with a high-quality icon and proper window grouping (**StartupWMClass**).
* **📦 Isolated Prefix:** Keeps all game data and Wine configurations separate from your system in `~/.abe_allstars`.
* **🛠️ Mod Compatibility:** Pre-configured with essential DLL overrides (`winhttp`) and automatic language detection (PT-BR).
* **📜 Logs & Debugging:** Generates installation logs for easy troubleshooting.

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
git clone [https://github.com/seu-usuario/seu-repositorio.git](https://github.com/seu-usuario/seu-repositorio.git)
cd seu-repositorio
Grant execution permission:

Bash
chmod +x launcher/run.sh
Launch the game:

Bash
./launcher/run.sh
[!TIP] Note: On the first run, a window will pop up asking you to select the folder containing the original Windows game files. After that, you can launch the game directly from your Application Menu.

📂 Folder Structure
Once installed, the launcher manages everything within the following directory:

~/.abe_allstars/ - Main directory containing game files and the Wine prefix.

~/.abe_allstars/run.sh - The permanent launcher (independent from the git folder).

~/.local/share/applications/ - Where the system menu shortcut is stored.
```
<p align="center"> Based on the <strong>Angry Birds Epic: All Stars</strong> community project.


Built with simplicity and performance in mind for the Linux community. </p>

<p align="center"> <img src="assets/icon.png" width="48" alt="Game Icon"> </p>
