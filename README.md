
# What is this?

This is a fork of [Ninlives/animated-wallpaper](https://github.com/Ninlives/animated-wallpaper) with the option to select which monitor to display the video on.

I want to have animated wallpaper on Gnome3, but there is no official support and I didn't find a good solution. [Komorebi](https://github.com/cheesecakeufo/komorebi) can create a dynamic desktop using a video but its functionality is bloated to me, so I recreate some of its core function into this small utility.



# Usage

```shell
Usage:
        animated-wallpaper options [FILE]
Options:
 -m     Select monitors. (eg. -n 0,2) Default: all
```

Play and loop the video `FILE` on your desktop.

# Build && Install

## Install

```shell
git clone https://github.com/DanielHands008/animated-wallpaper.git
cd animated-wallpaper
cmake .
make
make install
```

## For Nix Users

```shell
nix-env -i -f https://github.com/DanielHands008/animated-wallpaper/archive/master.tar.gz
```

# Note

- Will increase your CPU usage and lower your battery life

## Others

These instructions should work but I didn't test it, tell me if you encounter any problems.

### Requirements

- cmake
- vala
- pkgconfig
- gtk3
- clutter 
- clutter-gtk
- clutter-gst
- gst-libav