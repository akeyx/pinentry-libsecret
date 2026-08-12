# pinentry-libsecret

A modern, native Qt (PyQt6) `pinentry` wrapper for GnuPG (`gpg-agent`) that seamlessly integrates with **Freedesktop Secret Service API (`libsecret`)** (KeePassXC, KWallet, GNOME Keyring, 1Password, etc.), featuring silent passphrase retrieval and a desktop-native GUI fallback dialog with a **"Save in password manager"** checkbox.

---

## Background & Why This Exists

Standard `pinentry-qt` provided by GnuPG intentionally omits persistent password saving features. On modern Linux desktop environments (such as Fedora KDE Plasma 6), alternative tools like `pinentry-kwallet` are outdated or fail due to D-Bus changes.

`pinentry-libsecret` solves this by acting as a smart proxy for `gpg-agent` Assuan IPC protocol:
1. **Silent Unlock**: Automatically queries your active Secret Service provider over D-Bus (`libsecret`). If your GPG key passphrase exists in your unlocked password manager, operations like `sops`, `gpg`, and `git commit -S` authenticate **instantly without any popups**.
2. **Native Qt Fallback**: If the key is missing from your password manager, it opens a native Qt GUI dialog displaying cleanly formatted multi-line GPG key metadata and a **`[x] Save in password manager`** checkbox.
3. **Auto-Storage**: Checking the box automatically stores your passphrase via `secret-tool` under the key's Main ID.

---

## Features

- **Zero Hardcoded Keys**: Dynamically parses GPG Main Key IDs, Subkey IDs, and Keygrips directly from `gpg-agent` Assuan IPC commands on the fly.
- **Generic & Unopinionated**: Fully compatible with KeePassXC, KWallet, GNOME Keyring, 1Password, or any `libsecret` D-Bus provider.
- **Percent-Decoding**: Decodes Assuan percent-encoded strings (`%0A` $\rightarrow$ `\n`, `%22` $\rightarrow$ `"`) for clean, beautifully formatted multi-line GPG prompts.
- **Single Canonical Entry**: Deduplicates keys by storing exactly 1 canonical entry under the primary Main Key ID.

---

## Prerequisites

Ensure Python 3, PyQt6, and `libsecret-tools` (`secret-tool`) are installed:

### Fedora / RHEL
```bash
sudo dnf install -y python3-pyqt6 libsecret
```

### Ubuntu / Debian
```bash
sudo apt update && sudo apt install -y python3-pyqt6 libsecret-tools
```

### Arch Linux
```bash
sudo pacman -S python-pyqt6 libsecret
```

---

## Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/akeyx/pinentry-libsecret.git ~/projects/a.key/pinentry-libsecret
   ```

2. **Create Symlink in your PATH:**
   ```bash
   mkdir -p ~/bin
   ln -sf ~/projects/a.key/pinentry-libsecret/pinentry-libsecret ~/bin/pinentry-libsecret
   ```

3. **Configure `gpg-agent`:**
   Edit `~/.gnupg/gpg-agent.conf` and set:
   ```ini
   pinentry-program /home/a.key/bin/pinentry-libsecret
   ```
   *(Replace `/home/a.key` with your user's home directory path if needed).*

4. **Reload `gpg-agent`:**
   ```bash
   gpgconf --kill gpg-agent
   ```

---

## Usage & Workflow

1. Run any GPG operation or `sops` decryption command:
   ```bash
   sops secrets.enc.yaml
   ```
2. The native Qt dialog will pop up requesting your passphrase.
3. Keep **Save in password manager** checked and click **OK**.
4. Your Secret Service provider will store the passphrase under attribute `gpg-key = <MAIN_KEY_ID>`.
5. On all subsequent runs, `sops` and `gpg` will decrypt **silently with zero prompts**!

---

## Troubleshooting

- **Clear `gpg-agent` RAM cache:**
  ```bash
  gpgconf --kill gpg-agent
  ```
- **Remove saved key via CLI:**
  ```bash
  secret-tool clear gpg-key <MAIN_KEY_ID>
  ```

---

## License

[MIT License](LICENSE) &copy; 2026 a.key (akeyx)
