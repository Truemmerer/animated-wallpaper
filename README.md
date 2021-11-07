
# What is this?

This is a fork of [Ninlives/animated-wallpaper](https://github.com/Ninlives/animated-wallpaper) with the options to:
1. Select which monitors to display the video on.
2. Set the volume of the videos.
3. Generate a static background and set it for use where the video can't play.
4. Set a playlist of videos that automatically change over time.  

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
 -l	Set the location to for static backgrounds. (eg. -l /tmp/animated-backgrounds) default: /tmp
 -c	Don't generate static backgrounds. Make sure -l is set to a non-volatile location.
 -g	Only generate static backgrounds.
 -f	Generate static backgrounds even if file exists.
```

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

- Will increase your CPU and RAM usage and lower your battery life

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