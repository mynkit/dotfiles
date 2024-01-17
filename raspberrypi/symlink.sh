# init.vim (nvim)
mkdir -p "$HOME/.config/nvim"
rm "$HOME/.config/nvim/init.vim"
ln -s "$PWD/init.vim" "$HOME/.config/nvim/init.vim"
rm "$HOME/.bashrc"
ln -s "$PWD/.bashrc" "$HOME/.bashrc"
