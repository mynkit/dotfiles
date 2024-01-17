cd ~
git clone --recursive https://github.com/supercollider/sc3-plugins.git
cd sc3-plugins
mkdir build && cd build
# for both scsynth and supernova plugins; set -DSUPERNOVA=OFF to build only scsynth plugins
cmake -DSC_PATH=../../supercollider -DCMAKE_BUILD_TYPE=Release -DSUPERNOVA=ON ..
sudo cmake --build . --config Release --target install

