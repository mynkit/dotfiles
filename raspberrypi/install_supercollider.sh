# 日本語入力ソフトを導入
sudo apt-get update
sudo apt-get install fcitx-mozc

#ビルドに必要なライブラリをインストール
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt-get install libjack-jackd2-dev libsndfile1-dev libasound2-dev libavahi-client-dev libreadline-dev libfftw3-dev libxt-dev libudev-dev libncurses5-dev cmake git qttools5-dev qttools5-dev-tools qtdeclarative5-dev libqt5svg5-dev qjackctl libxcb-xinerama0 neovim

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

#SuperColliderのダウンロードとビルド
cd ~
git clone --recurse-submodules https://github.com/supercollider/supercollider.git
cd supercollider
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DSUPERNOVA=OFF -DSC_ED=OFF -DSC_EL=OFF -DSC_VIM=ON -DNATIVE=ON -DSC_USE_QTWEBENGINE:BOOL=OFF ..
cmake --build . --config Release --target all -- -j3
sudo cmake --build . --config Release --target install
sudo ldconfig

