#!/bin/bash

BREW_HOME="/home/linuxbrew/.linuxbrew"

# Ensure group exists and users are in it
sudo groupadd brewusers 2>/dev/null || echo "Group already exists, skipping..."
sudo usermod -aG brewusers tbryant
sudo usermod -aG brewusers openclaw

# Fix ownership and permissions on ALL subdirectories
sudo chown -R root:brewusers "$BREW_HOME"
sudo chmod -R 775 "$BREW_HOME"
sudo find "$BREW_HOME" -type d -exec chmod g+s {} \;

# Explicitly fix the specific dirs Homebrew complained about
DIRS=(
  Cellar Homebrew bin etc etc/bash_completion.d
  include lib lib/pkgconfig opt sbin share
  share/doc share/info share/man share/man/man1
  share/man/man7 share/zsh share/zsh/site-functions
  var/homebrew/linked var/homebrew/locks
)

for dir in "${DIRS[@]}"; do
  sudo chown root:brewusers "$BREW_HOME/$dir" 2>/dev/null
  sudo chmod 775 "$BREW_HOME/$dir" 2>/dev/null
  sudo chmod g+s "$BREW_HOME/$dir" 2>/dev/null
done

echo "Done! Log out and back in if you haven't already."
