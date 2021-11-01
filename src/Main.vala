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
        int monitor = -1;
        string fileName = "";

        if (args.length < 2)
            showHelp();

        for (int i = 1; i < args.length; i++) {
            if (args[i][0] == '-' && args[i].length == 2) {
                switch (args[i][1])
                {
                    case 'm':
                        if (args.length > i){
                            monitor = int.parse(args[i + 1]);
                            i++;
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

        backgroundWindows = new BackgroundWindow[monitorCount];
        if(monitor == -1)
            for (int i = 0; i < monitorCount; ++i)
                backgroundWindows[i] = new BackgroundWindow(i, fileName);
        else
            backgroundWindows[monitor] = new BackgroundWindow(monitor, fileName);


        var mainSettings = Gtk.Settings.get_default ();
        mainSettings.set("gtk-xft-antialias", 1, null);
        mainSettings.set("gtk-xft-rgba" , "none", null);
        mainSettings.set("gtk-xft-hintstyle" , "slight", null);

        for (int i = 0; i < monitorCount; ++i)
            backgroundWindows[i].show_all();

        Clutter.main();
    }

    public static void showHelp() {
        print("Usage:\n\tanimated-wallpaper options [FILE]\n");
        print("Options:\n -m\tSelect monitor. (-1 = all monitors.) Default: -1\n");

        Process.exit(0);
    }
}
