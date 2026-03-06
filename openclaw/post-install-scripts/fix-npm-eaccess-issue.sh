#!/bin/bash
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

# Add to bashrc if it exists
if [ -f ~/.bashrc ]; then
    echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
fi

# Add to zshrc if it exists
if [ -f ~/.zshrc ]; then
    echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc
fi

echo "Done! Run: source ~/.bashrc (or ~/.zshrc)"
