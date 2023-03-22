//
// Copyright 2018-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application.Storage;

//! This delegate is for the main page of our application that pushes the menu
//! when the onMenu() behavior is received.
class PiquetCalculatorDelegate extends WatchUi.BehaviorDelegate
{
    //! Constructor
    public function initialize()
    {
        BehaviorDelegate.initialize();

        if(Storage.getValue("startTime") == null)
        {
            Storage.setValue("startTime", WatchUi.loadResource($.Rez.Strings.startTime) as String);
        }
    
        if(Storage.getValue("endTime") == null)
        {
            Storage.setValue("endTime", WatchUi.loadResource($.Rez.Strings.endTime) as String);
        }

        if(Storage.getValue("numberOfPers") == null)
        {
            Storage.setValue("numberOfPers", WatchUi.loadResource($.Rez.Strings.numberOfPers) as String);
        }

        if(Storage.getValue("staggering") == null)
        {
            Storage.setValue("staggering", WatchUi.loadResource($.Rez.Strings.staggering) as String);
        }
    }

    //! Handle the menu event
    //! @return true if handled, false otherwise
    public function LoadMenu()
    {
        // Generate a new Menu with a drawable Title
        var menu = new WatchUi.Menu2({:title=>new $.DrawableMenuTitle()});

        // Add menu items for demonstrating toggles, checkbox and icon menu items
        menu.addItem(new WatchUi.MenuItem("Start Time", Storage.getValue("startTime"), "startTime", null));
        menu.addItem(new WatchUi.MenuItem("End Time", Storage.getValue("endTime"), "endTime", null));
        menu.addItem(new WatchUi.MenuItem("Number of Pers", Storage.getValue("numberOfPers"), "numberOfPers", null));
        menu.addItem(new WatchUi.MenuItem("Staggering", Storage.getValue("staggering"), "staggering", null));
        menu.addItem(new WatchUi.MenuItem("Calculate", null, "calculate", null));
        WatchUi.pushView(menu, new $.PiquetOptionsDelegate(), WatchUi.SLIDE_UP);
    }
}

//! This is the custom drawable we will use for our main menu title
class DrawableMenuTitle extends WatchUi.Drawable
{

    //! Constructor
    public function initialize()
    {
        Drawable.initialize({});
    }

    //! Draw the application icon and main menu title
    //! @param dc Device Context
    public function draw(dc as Dc) as Void
    {
        var spacing = 2;
        var appIcon = WatchUi.loadResource($.Rez.Drawables.LauncherIcon) as BitmapResource;
        var bitmapWidth = appIcon.getWidth();
        var labelWidth = dc.getTextWidthInPixels("Piquet", Graphics.FONT_MEDIUM);

        var bitmapX = (dc.getWidth() - (bitmapWidth + spacing + labelWidth)) / 2;
        //var bitmapY = (dc.getHeight() - appIcon.getHeight()) / 2;
        var labelX = bitmapX + bitmapWidth + spacing;
        var labelY = dc.getHeight() / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        //dc.drawBitmap(bitmapX, bitmapY, appIcon);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(labelX, labelY, Graphics.FONT_MEDIUM, "Piquet", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}
