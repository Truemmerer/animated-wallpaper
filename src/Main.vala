//
//  Copyright (C) 2016-2017 Abraham Masri
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

using Playable;
namespace Wallpaper {
    bool debug = false;
    bool randomOrder = false;
    int currentPos = 0;
    unowned string playlist = "";
    bool useStaticBackground = false;
    unowned string staticLocation = "/tmp";
    bool generateStaticBackgrounds = true;
    bool forceGenerateStaticBackgrounds = false;
    BackgroundWindow[] backgroundWindows;
    double volume = 0;
    unowned string ffmpegSeek = "00:00:00";
    int interval = 600000;
    bool onlyGenerateStaticBackgrounds = false;

    private static bool checkValue(string [] args, int position, string valueType) {
        if (args.length > position) {
            if (valueType == "string")
                return true;
            else if (valueType == "int" || valueType == "double") {
                int valueTmp = int.parse(args[position + 1]);
                if(valueTmp.to_string() == args[position + 1])
                    return true;
                if (valueType == "double" && checkValueDouble(args, position))
                    return true;
            }
            else if (valueType == "folder") {

            }
        }
        print ("Error: invalid value for " + args[position] + "\n");
        Process.exit(0);
        return false;
    }
    private static bool checkValueDouble (string [] args, int position) {
        double doubleTmp;
        if (!double.try_parse (args[position + 1], out doubleTmp)) {
            print ("Error: invalid value for " + args[position] + "\n");
            Process.exit(0);
            return false;
        }
        return true;
    }
    private static bool checkFileExists(string path) {
        File file = File.new_for_path (path);
        if (file.query_exists())
            return true;
        else {
            print("Error: file does not exist. " + path + "\n");
            return false;
        }
    }

    public static void main (string [] args) {

        int[] monitors = new int[0];

        if (args.length < 2)
            showHelp();

        for (int i = 1; i < args.length; i++) {
            if (args[i][0] == '-' && args[i].length == 2) {
                switch (args[i][1])
                {
                    case 'd':
                        debug = true;
                        break;
                    case 'm':
                        if (checkValue(args, i, "string")) {
                            if (args[i + 1] == "all")
                                break;
                            string[] tmp = args[i + 1].split(",");
                            monitors.resize(tmp.length);
                            for(int o = 0; o < tmp.length; o++)
                                monitors[o] = int.parse(tmp[o]);
                            i++;
                        }
                        break;
                    case 'v':
                        if (checkValue(args, i, "double")) {
                            volume = double.parse(args[i + 1]);
                            i++;
                        }
                        break;
                    case 's':
                        useStaticBackground = true;
                        break;
                    case 't':
                        if (checkValue(args, i, "string")) {
                            ffmpegSeek = args[i + 1];
                        }
                        break;
                    case 'p':
                        if (args.length > i) {
                            playlist = args[i + 1];
                        }
                        break;
                    case 'i':
                        if (checkValue(args, i, "int")) {
                            interval = int.parse(args[i + 1]) * 1000;
                        }
                        break;
                    case 'r':
                        randomOrder = true;
                        break;
                    case 'l':
                        if (checkValue(args, i, "folder")) {
                            staticLocation = args[i + 1];
                        }
                        break;
                    case 'c':
                        generateStaticBackgrounds = false;
                        break;
                    case 'g':
                        onlyGenerateStaticBackgrounds = true;
                        useStaticBackground = true;
                        break;
                    case 'f':
                        forceGenerateStaticBackgrounds = true;
                        break;
                    case 'h':
                    default:
                        showHelp();
                        break;
                }
            }

            if (i == args.length - 1 && playlist == "") {
                if (checkFileExists(args[i]))
                    playlist = args[i];
                else
                    Process.exit(0);
            }
        }

        string[] playlistArray = playlist.split(",");

        if (useStaticBackground && generateStaticBackgrounds) {
            if(debug) print("Use static\n");
            for(int i = 0; i < playlistArray.length; i++) {

                string[] fileParts = playlistArray[i].split("/");
                File file = File.new_for_path (staticLocation + "/" + fileParts[fileParts.length - 1] + ".png");
                bool exists = file.query_exists ();

                if(debug) print("File: " + playlistArray[i] + "\n");
                if(debug) print("Exists: " + exists.to_string() + "\n");

                if(!exists || forceGenerateStaticBackgrounds)
                    makeStaticBackgrounds(playlistArray[i], ffmpegSeek);
            }

        }

        if(onlyGenerateStaticBackgrounds)
            Process.exit(0);
        
        GtkClutter.init (ref args);
        Gtk.init (ref args);
        Gst.init (ref args);

        var screen = Gdk.Screen.get_default ();
        int monitorCount = screen.get_n_monitors();

        if(monitors.length == 0) {
            backgroundWindows = new BackgroundWindow[monitorCount];
            for (int i = 0; i < monitorCount; ++i) {
                    double monitorVolume = 0;
                    if (i == 0) monitorVolume = volume;
                    backgroundWindows[i] = new BackgroundWindow(i, playlistArray[0], monitorVolume);
            }
        }

        else {
            backgroundWindows = new BackgroundWindow[monitors.length];
            for(int i = 0; i < monitors.length; i++) {
                    double monitorVolume = 0;
                    if (i == 0) monitorVolume = volume;
                    backgroundWindows[monitors[i]] = new BackgroundWindow(monitors[i], playlistArray[0], monitorVolume);
            }
        }



        var mainSettings = Gtk.Settings.get_default ();
        mainSettings.set("gtk-xft-antialias", 1, null);
        mainSettings.set("gtk-xft-rgba" , "none", null);
        mainSettings.set("gtk-xft-hintstyle" , "slight", null);

        for (int i = 0; i < backgroundWindows.length; ++i)
            backgroundWindows[i].show_all();

        uint timerID;
        if (playlistArray.length > 1)
            timerID = Timeout.add (interval, changeWallpaper);

        if (useStaticBackground) {
            if (playlistArray.length == 0)
                setStaticBackground(playlistArray[0]);
            else if(randomOrder)
                changeWallpaper();
            else
                setStaticBackground(playlistArray[0]);
        }

        Clutter.main();


    }

    public bool changeWallpaper () {
        string[] playlistArray = playlist.split(",");
        if (playlistArray.length < 2)
            return true;

        if (!randomOrder) {
            currentPos++;
        }
        else {
            int oldPos = currentPos;
            while (oldPos == currentPos)
            {
                currentPos = Random.int_range(0, playlistArray.length);
            }
        }
        if (currentPos >= playlistArray.length)
            currentPos = 0;

        if(debug) print ("Set background: " + currentPos.to_string() + "\n");

        for (int i = 0; i < backgroundWindows.length; i++)
            backgroundWindows[i].setVideoWallpaper(playlistArray[currentPos], 0);
        if (useStaticBackground)
            setStaticBackground(playlistArray[currentPos]);

        return true;
    }

    public static void makeStaticBackgrounds(string fileName, string ffmpegSeek) {
        string[] fileParts = fileName.split("/");
        string ls_stdout;
        string ls_stderr;
        int ls_status;
        try {
            string ffmpegCommand = "ffmpeg -y -i \"" + fileName + "\" -ss " + ffmpegSeek + " -frames:v 1 " + staticLocation + "/" + fileParts[fileParts.length - 1] + ".png";
            if(debug) print(ffmpegCommand + "\n");
            Process.spawn_command_line_sync (ffmpegCommand, out ls_stdout, out ls_stderr, out ls_status);

            if(debug) print ("stdout:\n");
            if(debug) print (ls_stdout);
            if(debug) print ("stderr:\n");
            if(debug) print (ls_stderr);
            if(debug) print ("Status: %d\n", ls_status);

        } catch (SpawnError e) {
            print ("Error: %s\n", e.message);
        }
    }

    public static void setStaticBackground(string fileName) {
        string[] fileParts = fileName.split("/");
        string ls_stdout;
        string ls_stderr;
        int ls_status;
        try {
            string setBackgroundCommand = "gsettings set org.gnome.desktop.background picture-uri file://" + staticLocation + "/" + fileParts[fileParts.length - 1] + ".png";
            if(debug) print(setBackgroundCommand + "\n");
            Process.spawn_command_line_sync (setBackgroundCommand, out ls_stdout, out ls_stderr, out ls_status);
            if(debug) print ("stdout:\n");
            if(debug) print (ls_stdout);
            if(debug) print ("stderr:\n");
            if(debug) print (ls_stderr);
            if(debug) print ("Status: %d\n", ls_status);
        } catch (SpawnError e) {
            print ("Error: %s\n", e.message);
        }
    }

    public static void showHelp() {
        print("Usage:\n\tanimated-wallpaper options [FILE]\n");
        print("Options:\n");
        print(" -d\tEnable debug mode.\n");
        print(" -m\tSelect monitors. (eg. -n 0,2) Default: all\n");
        print(" -v\tSet volume. (eg. -v 0.2) Default: 0\n");
        print(" -s\tSet the static background to a frame from the video. (Requires ffmpeg)\n");
        print(" -t\tTime in the video the static background is taken from. (eg. -t 00:00:05) Default: 00:00:00\n");
        print(" -p\tPlaylist of videos. (eg. -p \"video1.mp4,video2.mp4,video3.mp4\")\n");
        print(" -i\tInterval in seconds between backgrounds. (eg. -i 900) Default: 600\n");
        print(" -r\tShow backgrounds in a random order.\n");
        print(" -l\tSet the location to for static backgrounds. (eg. -l /tmp/animated-backgrounds) default: /tmp\n");
        print(" -c\tDon't generate static backgrounds. Make sure -l is set to a non-volatile location.\n");
        print(" -g\tOnly generate static backgrounds.\n");
        print(" -f\tGenerate static backgrounds even if file exists.\n");

        Process.exit(0);
    }
}
