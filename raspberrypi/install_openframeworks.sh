sudo apt-get install -y libcairo2-dev libgstreamer* libopenal-dev libcurl4-openssl-dev libglew-dev librtaudio-dev libfreeimage-dev liburiparser-dev libglfw3-dev libpugixml-dev libboost-filesystem-dev libboost-system-dev xorg

mkdir ~/openFrameworks
cd ~/openFrameworks
wget https://github.com/openframeworks/openFrameworks/releases/download/0.11.2/of_v0.11.2_linuxarmv6l_release.tar.gz
tar -zxvf of_v0.11.2_linuxarmv6l_release.tar.gz

# ~/openFrameworks/of_v0.11.2_linuxarmv6l_release/libs/openFrameworksCompiled/project/linuxarmv6l/config.linuxarmv6l.default.mk に PLATFORM_PKG_CONFIG_LIBRARIES += rtaudio を追記
# PLATFORM_LIBRARIES += openmaxil をコメントアウト

