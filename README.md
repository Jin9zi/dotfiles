## openSUSE Fish setup

My setup script for installing Fish, Starship, useful terminal tools, and JetBrainsMono Nerd Font on openSUSE.

### What it does

- Installs Fish, Git, GNU Stow, fzf, ripgrep, fd, bat, zoxide, and Fastfetch.
- Attempts to install eza, with exa as a fallback.
- Installs Starship if it is missing.
- Clones or updates my dotfiles in `~/dotfiles`.
- Backs up existing Fish and Starship configurations before linking the dotfiles.
- Adds Starship and zoxide initialization to Fish.
- Installs Fisher and the fzf Fish plugin.
- Downloads JetBrainsMono Nerd Font.
- Attempts to set Fish as the default shell.

### Usage

Download `suse_fish_autorice.sh` from this repository, then run:

```bash
cd ~/Downloads
bash suse_fish_autorice.sh
```

Run it as your normal user. The script asks for your sudo password when installing packages.

After completion, reopen your terminal. In Konsole, select the font under:

**Settings → Edit Current Profile → Appearance → Font**

Choose **JetBrainsMono Nerd Font**.

### Notes

This script uses my dotfiles from:
https://github.com/Jin9zi/dotfiles

It changes your shell configuration and downloads installers and plugins from the internet. Read the script before running it.

Existing Fish and Starship configurations are backed up with a `.bak.TIMESTAMP` suffix. Other configuration conflicts may cause GNU Stow to stop.

Because Fish configuration is linked to the repository, settings added by the script may appear as local Git changes.
