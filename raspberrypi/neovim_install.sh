# vim-commentary
mkdir -p ~/.config/nvim/pack/tpope/start
cd ~/.config/nvim/pack/tpope/start
git clone https://tpope.io/vim/commentary.git
nvim -u NONE -c "helptags commentary/doc" -c q

