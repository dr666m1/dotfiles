#!/bin/bash
cd $(dirname $0)

# zsh
sed --in-place "\%# Added by dotfiles/init.sh%d" $HOME/.zshrc
echo "source $(pwd)/.zshrc # Added by dotfiles/init.sh" >> $HOME/.zshrc

# Git
mkdir -p $HOME/.config
rm -r $HOME/.config/git &> /dev/null
ln -s $(pwd)/git $HOME/.config/git

# Neovim
rm -r $HOME/.config/nvim &> /dev/null
rm -r $HOME/.config/coc/ultisnips &> /dev/null
ln -s $(pwd)/nvim $HOME/.config/nvim
ln -s $(pwd)/nvim/snips $HOME/.config/coc/ultisnips

# tmux
rm $HOME/.tmux.conf &> /dev/null
ln -s $(pwd)/.tmux.conf $HOME/.tmux.conf
