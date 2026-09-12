# dotfiles

## zshrc

```sh
sh git_completion_install.sh
ln -s "$PWD/.zshrc" "$HOME/.zshrc"
```

## PowerShell (Windows)

gitリポジトリ内でブランチ名と状態記号を表示するプロンプト設定 ([windows/Microsoft.PowerShell_profile.ps1](windows/Microsoft.PowerShell_profile.ps1))。

```
PS C:\Users\xxx\github\dotfiles (main* =) >
```

| 記号 | 意味 |
|---|---|
| `*` | 未ステージの変更あり |
| `+` | ステージ済みの変更あり |
| `=` | リモートと同期済み |
| `>` / `<` | リモートより先行 / 遅れ |
| `<>` | 分岐 (両方あり) |

セットアップ (PowerShellで実行):

```powershell
# posh-git のインストール
Install-Module posh-git -Scope CurrentUser -Force

# プロファイル等のローカルスクリプトの実行を許可
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned

# プロファイルからこのリポジトリの設定を読み込む
New-Item -ItemType Directory -Force (Split-Path $PROFILE) | Out-Null
'. "$HOME\github\dotfiles\windows\Microsoft.PowerShell_profile.ps1"' | Set-Content $PROFILE
```

新しいPowerShellウィンドウを開くと反映される。

注意: Windows PowerShell 5.1 はBOMなしUTF-8をANSIとして読むため、`windows/` 配下の `.ps1` はBOM付きUTF-8で保存すること。

## bin (自作コマンド)

`.zshrc` で `$HOME/.local/bin` に PATH が通っているので、そこにシンボリックリンクを貼る。

```sh
mkdir -p "$HOME/.local/bin"
ln -s "$PWD/bin/menubar" "$HOME/.local/bin/menubar"
```

### menubar

macOS のメニューバーの自動非表示を切り替える。
GUI だと システム設定 → コントロールセンター → 「メニューバーを自動的に表示/非表示」。

```sh
menubar         # トグル
menubar hide    # 常に隠す (カーソルを合わせたときだけ表示)
menubar show    # 常に表示
menubar status  # 現在の状態
```

`defaults write -g _HIHideMenuBar` は macOS がログイン時にしか読まず即座に反映されないため、
System Events 経由で設定している。初回実行時に「システムイベント」へのオートメーション許可を求められる。

## neovim

Apply `init.vim`

```sh
mkdir -p "$HOME/.config/nvim/init.vim"
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

# TidalCycles + SuperCollider

```haskell

s_new "pinknoise" 1000 [string "amp", Float 0.0]

n_free 1000

n_set 1000 [string "amp", Float 0.3, string "hpf", Float 4700, string "lpf", Float 470]

p "pinknoise"
  $ slow 1
  $ "tick"
  # amp "<0.1 0.5 0.8 0.4>"
  # nodeId 1000

```


```
cycle_n_set synthname 

do
  p "superhammondSc1"
    $ slow 4
    $ "tick"
    # amp "<0.3 0.3>"
    # freq "<138.59 184.99>"
    # nodeId 1000
  p "superhammondSc2"
    $ slow 4
    $ "tick"
    # amp "<0.3 0.3>"
    # freq "<207.65 277.18>"
    # nodeId 1000
  p "superhammondSc3"
    $ slow 4
    $ "tick"
    # amp "<0.3 0.3>"
    # freq "<164.81 220.00>"
    # nodeId 1000
  p "superhammondSc4"
    $ slow 4
    $ "tick"
    # amp "<0.3 0.3>"
    # freq "<69.29 92.49>"
    # nodeId 1000

```

138.5915
207.6526252449546
164.8139978788996
69.29575

184.99745764920632
277.183
220.00029289385068
92.49872882460316

```python
def cal(n):
  print(277.183*0.5*(2**((0+n)/12)))
  print(277.183*0.5*(2**((7+n)/12)))
  print(277.183*0.5*(2**((3+n)/12)))
  print(277.183*0.5*(2**((-12+n)/12)))

```
