# pinentry-libsecret

A modern, multi-toolkit `pinentry` wrapper for GnuPG (`gpg-agent`) that seamlessly integrates with **Freedesktop Secret Service API (`libsecret`)** (KeePassXC, KWallet, GNOME Keyring, 1Password, etc.), featuring silent passphrase retrieval and desktop-native GUI fallback prompts with a **"Save in password manager"** checkbox.

---

## Features

- **Automated CI Releases**: Pre-built **`.rpm`** and **`.deb`** packages automatically built and attached to every GitHub Release.
- **Multi-Toolkit GUI Prompts**: Supports **PyQt6**, **`kdialog`** (KDE), and **`zenity`** (GTK/GNOME).
- **Environment & CLI Configurable**: Select your preferred GUI toolkit or fallback binary via env vars (`PINENTRY_LIBSECRET_TOOLKIT`) or CLI flags (`--toolkit=...`).
- **Zero Hardcoded Keys**: Dynamically parses GPG Main Key IDs, Subkey IDs, and Keygrips directly from `gpg-agent` Assuan IPC commands on the fly.
- **Generic & Unopinionated**: Fully compatible with KeePassXC, KWallet, GNOME Keyring, 1Password, or any `libsecret` D-Bus provider.
- **Percent-Decoding**: Decodes Assuan percent-encoded strings (`%0A` $\rightarrow$ `\n`, `%22` $\rightarrow$ `"`) for clean, beautifully formatted multi-line GPG prompts.
- **System Fallback Cascade**: Intelligently falls back to `pinentry-qt`, `pinentry-gnome3`, `pinentry-gtk-2`, `pinentry-gtk`, or `pinentry-curses` if no GUI dialog toolkits are available.

---

## Installation Options

### Option 1: Quick 1-Line Installer (Recommended)

Run this one-liner in your terminal to download, install to `~/.local/bin/`, update `~/.gnupg/gpg-agent.conf`, and reload `gpg-agent`:

```bash
curl -sSL https://raw.githubusercontent.com/akeyx/pinentry-libsecret/main/install.sh | bash
```

---

### Option 2: Pre-built `.rpm` or `.deb` Packages

Download the latest `.rpm` or `.deb` package from **[GitHub Releases](https://github.com/akeyx/pinentry-libsecret/releases)**:

#### Fedora / RHEL / SUSE:
```bash
sudo dnf install ./pinentry-libsecret-1.0.0-1.noarch.rpm
```

#### Ubuntu / Debian / Mint:
```bash
sudo apt install ./pinentry-libsecret_1.0.0_all.deb
```

Then configure `~/.gnupg/gpg-agent.conf`:
```ini
pinentry-program /usr/bin/pinentry-libsecret
```
And reload `gpg-agent`: `gpgconf --kill gpg-agent`.

---

### Option 3: Manual Clone & Symlink

```bash
git clone https://github.com/akeyx/pinentry-libsecret.git ~/projects/a.key/pinentry-libsecret
mkdir -p ~/bin
ln -sf ~/projects/a.key/pinentry-libsecret/pinentry-libsecret ~/bin/pinentry-libsecret
```

Configure `~/.gnupg/gpg-agent.conf`:
```ini
pinentry-program /home/a.key/bin/pinentry-libsecret
```
And reload `gpg-agent`: `gpgconf --kill gpg-agent`.

---

## Configuration & Switches

### Environment Variables

| Variable | Values | Description |
| :--- | :--- | :--- |
| `PINENTRY_LIBSECRET_TOOLKIT` | `auto`, `pyqt`, `kdialog`, `zenity` | Preferred GUI toolkit (`auto` tries PyQt $\rightarrow$ kdialog $\rightarrow$ zenity). |
| `PINENTRY_LIBSECRET_FALLBACK` | `/path/to/pinentry` | Custom fallback binary if GUI prompts are unavailable. |

### CLI Switches (in `gpg-agent.conf`)

Pass configuration switches directly in `~/.gnupg/gpg-agent.conf`:

```ini
pinentry-program /usr/bin/pinentry-libsecret --toolkit=auto --fallback-pinentry=/usr/bin/pinentry-gnome3
```

---

## Usage & Workflow

1. Run any GPG operation or `sops` decryption command:
   ```bash
   sops secrets.enc.yaml
   ```
2. The desktop dialog will pop up requesting your passphrase.
3. Keep **Save in password manager** checked and click **OK**.
4. Your Secret Service provider will store the passphrase under attribute `gpg-key = <MAIN_KEY_ID>`.
5. On all subsequent runs, `sops` and `gpg` will decrypt **silently with zero prompts**!

---

## License

[MIT License](LICENSE) &copy; 2026 a.key (akeyx)
