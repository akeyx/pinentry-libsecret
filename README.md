# pinentry-keepassxc

A lightweight, dynamic Pinentry wrapper for GnuPG (`gpg-agent`) that automatically fetches GPG passphrases from **KeePassXC** (or any `libsecret` provider via `secret-tool`), with seamless fallback to `pinentry-qt`.

## Features
- **Zero Hardcoding**: Dynamically parses GPG Main Key ID, Subkey ID, and Keygrip from Assuan protocol streams.
- **Flexible Lookup**:
  1. Searches KeePassXC attribute `gpg-key = <MAIN_KEY_ID>`
  2. Searches KeePassXC attribute `gpg-key = <SUBKEY_ID>`
  3. Searches KeePassXC attribute `keygrip = <KEYGRIP>`
  4. Searches KeePassXC entry Title `GPG Key`
- **Graceful Fallback**: If KeePassXC is locked or does not contain the key, seamlessly falls back to `pinentry-qt` GUI prompt.

## Installation
1. Symlink to `~/bin/`:
   ```bash
   ln -sf ~/projects/a.key/pinentry-keepassxc/pinentry-keepassxc ~/bin/pinentry-keepassxc
   ```
2. Configure `~/.gnupg/gpg-agent.conf`:
   ```ini
   pinentry-program /home/a.key/bin/pinentry-keepassxc
   ```
3. Reload `gpg-agent`:
   ```bash
   gpgconf --kill gpg-agent
   ```
