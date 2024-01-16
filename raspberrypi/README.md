# dotfiles for RasberryPi 

## Device

Raspberry Pi4 Model B (8GB RAM)

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



