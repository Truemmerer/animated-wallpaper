
This is a fork from https://github.com/DanielHands008/animated-wallpaper.
This fork is only based on a version that was stable.
And serves only as a basis for https://github.com/Truemmerer/animated_wallpaper_helper

# What is this?

This is a fork of [Ninlives/animated-wallpaper](https://github.com/Ninlives/animated-wallpaper) with the option to select which monitor to display the video on.

I want to have animated wallpaper on Gnome3, but there is no official support and I didn't find a good solution. [Komorebi](https://github.com/cheesecakeufo/komorebi) can create a dynamic desktop using a video but its functionality is bloated to me, so I recreate some of its core function into this small utility.



# Usage

```shell
Usage:
	animated-wallpaper options [FILE]
Options:
 -d	Enable debug mode.
 -m	Select monitors. (eg. -n 0,2) Default: all
 -v	Set volume. (eg. -v 0.2) Default: 0
 -s	Set the static background to a frame from the video. (Requires ffmpeg)
 -t	Time in the video the static background is taken from. (eg. -t 00:00:05) Default: 00:00:00
 -p	Playlist of videos. (eg. -p "video1.mp4,video2.mp4,video3.mp4")
 -i	Interval in seconds between backgrounds. (eg. -i 900) Default: 600
 -r	Show backgrounds in a random order.
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
