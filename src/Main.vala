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

    BackgroundWindow[] backgroundWindows;

    public static void main (string [] args) {

        int[] monitors = new int[0];
        string fileName = "";
        double volume = 0;

        if (args.length < 2)
            showHelp();

        for (int i = 1; i < args.length; i++) {
            if (args[i][0] == '-' && args[i].length == 2) {
                switch (args[i][1])
                {
                    case 'm':
                        if (args.length > i){
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
                        if (args.length > i){
                            volume = double.parse(args[i + 1]);
                        }
                        break;
                    case 'h':
                    default:
                        showHelp();
                        break;
                }
            }
        
            if (i == args.length - 1)
                fileName = args[i];

        }

        GtkClutter.init (ref args);
        Gtk.init (ref args);
        Gst.init (ref args);

        var screen = Gdk.Screen.get_default ();
        int monitorCount = screen.get_n_monitors();

        
        if(monitors.length == 0) {
            backgroundWindows = new BackgroundWindow[monitorCount];
            for (int i = 0; i < monitorCount; ++i)
                backgroundWindows[i] = new BackgroundWindow(i, fileName, volume);
        }

        else {
            backgroundWindows = new BackgroundWindow[monitors.length];
            for(int i = 0; i < monitors.length; i++)
                backgroundWindows[monitors[i]] = new BackgroundWindow(monitors[i], fileName, volume);
        }



        var mainSettings = Gtk.Settings.get_default ();
        mainSettings.set("gtk-xft-antialias", 1, null);
        mainSettings.set("gtk-xft-rgba" , "none", null);
        mainSettings.set("gtk-xft-hintstyle" , "slight", null);

        for (int i = 0; i < backgroundWindows.length; ++i)
            backgroundWindows[i].show_all();

        Clutter.main();
    }

    public static void showHelp() {
        print("Usage:\n\tanimated-wallpaper options [FILE]\n");
        print("Options:\n");
        print(" -m\tSelect monitors. (eg. -n 0,2) Default: all\n");
        print(" -v\tSet volume. (eg. -v 0.2) Default: 0\n");

        Process.exit(0);
    }
}
