# init.vim (nvim)
mkdir -p "$HOME/.config/nvim/init.vim"
ln -s "$PWD/init.vim" "$HOME/.config/nvim/init.vim"
ln -s "$PWD/startup.scd" "$HOME/Library/Application Support/SuperCollider/startup.scd"
ln -s "$PWD/BootTidal.hs" "$HOME/BootTidal.hs"
ln -s "$PWD/.zshrc" "$HOME/.zshrc"

# 自作コマンド (.zshrc で $HOME/.local/bin に PATH が通っている)
mkdir -p "$HOME/.local/bin"
ln -s "$PWD/bin/menubar" "$HOME/.local/bin/menubar"
