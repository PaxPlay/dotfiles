#!/bin/bash

# Check and backup existing Neovim configuration
if [ -d "$HOME/.config/nvim" ]; then
    echo "Backing up existing Neovim configuration..."
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
fi

# fetch dotfiles repository
echo "Cloning dotfiles repository..."
git clone https://github.com/PaxPlay/dotfiles.git $HOME/.config/dotfiles
if [ $? -ne 0 ]; then
    echo "Failed to clone dotfiles repository."
    exit 1
fi

# link Neovim configuration
echo "Linking Neovim configuration..."
ln -s $HOME/.config/dotfiles/nvim-lua $HOME/.config/nvim
if [ $? -ne 0 ]; then
    echo "Failed to link Neovim configuration."
    exit 1
fi
