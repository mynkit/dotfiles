# dotfiles

## zshrc

```sh
sh git_completion_install.sh
ln -s "$PWD/.zshrc" "$HOME/.zshrc"
```

## neovim

Apply `init.vim`

```sh
mkdir -p "$HOME/.config/nvim"
ln -s "$PWD/dotfiles/init.vim" "$HOME/.config/nvim/init.vim"
```

## TidalCycles

SuperDirt is from the following repositories.

https://github.com/mynkit/SuperDirt

Installation via SuperCollider Editor

```SuperCollider
Quarks.install("https://github.com/mynkit/SuperDirt.git");
```

Overwrite SuperCollider startup files.

```sh
rm "$HOME/Library/Application Support/SuperCollider/startup.scd"
ln -s "$PWD/startup.scd" "$HOME/Library/Application Support/SuperCollider/startup.scd"
```

Overwrite `BootTidal.hs`.

```sh
ln -s "$PWD/BootTidal.hs" "$HOME/BootTidal.hs"
```


