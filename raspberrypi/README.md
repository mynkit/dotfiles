# dotfiles for RasberryPi 

## Device

Raspberry Pi4 Model B (8GB RAM)

## OS

bullseye 32bit


## SuperCollider

install supercollider

```
/bin/bash/ install_supercollider.sh 
```

install sc3-plugins

```
install_sc3-plugins.sh
```

install superdirt & other packages

`sclang`を実行後、

```
Quarks.install("https://github.com/mynkit/SuperDirt.git");
Quarks.install("https://github.com/ambisonictoolkit/atk-sc3.git");
thisProcess.recompile();
Atk.downloadKernels;
Atk.downloadMatrices;
Atk.downloadSounds;
```


## First Setting

`sudo vim /boot/config.txt`

して、最下部に以下を追記

```diff
[all]
+ gpu_mem=512
```

`#uncomment to overclock the arm. 700 MHz is the default.`の下を以下に書き換え

```diff
#uncomment to overclock the arm. 700 MHz is the default.
#arm_freq=800
arm_freq=2000
over_voltage=6
force_turbo=1
```

