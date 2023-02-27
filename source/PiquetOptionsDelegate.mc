
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application.Storage;

//! This is the menu input delegate for the main menu of the application
class PiquetOptionsDelegate extends WatchUi.Menu2InputDelegate
{
    
    //! Constructor
    public function initialize()
    {
        Menu2InputDelegate.initialize();
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void
    {
        var id = item.getId() as String;

        switch(id)
        {
            case "startTime":
            case "endTime":
                WatchUi.pushView(new $.TimePicker(id), new $.TimePickerDelegate(item), WatchUi.SLIDE_IMMEDIATE);
                break;
            case "numberOfPers":                
                WatchUi.pushView(new $.NumberPicker(id), new $.NumberPickerDelegate(item), WatchUi.SLIDE_IMMEDIATE);
                break;
            case "staggering":
                // Generate a new Menu with a drawable Title
                var staggeringMenu = new WatchUi.Menu2({:title=>new $.DrawableMenuTitle()});
                // Add menu items for demonstrating toggles, checkbox and icon menu items
                staggeringMenu.addItem(new WatchUi.MenuItem("Single Staggered", null, "singleStaggered", null));
                staggeringMenu.addItem(new WatchUi.MenuItem("Double Staggered", null, "doubleStaggered", null));
                WatchUi.pushView(staggeringMenu, new $.StaggeringMenuDelegate(item), WatchUi.SLIDE_UP);
                break;
            case "calculate":
                calculate();
                break;
            default:
                WatchUi.requestUpdate();
        }
    }

    public function calculate()
    {
        // Generate a new Menu with a drawable Title
        var menu = new WatchUi.Menu2({:title=>new $.DrawableMenuTitle()});
        var numberOfPers = Storage.getValue("numberOfPers").toNumber();

        //TODO: Remove constant $.FACTORY_COUNT_24_HOUR
        var storedStartTime = TimePicker.splitStoredTime($.FACTORY_COUNT_24_HOUR, Storage.getValue("startTime"));
        var storedEndTime = TimePicker.splitStoredTime($.FACTORY_COUNT_24_HOUR, Storage.getValue("endTime"));

        for(var i=0; i<numberOfPers; ++i)
        {
            menu.addItem(new WatchUi.MenuItem((i+1)+". "+ storedStartTime[0] + ":" + storedStartTime[1] + " - "+ storedEndTime[0] + ":" + storedEndTime[1], null, "line"+(i+1), null));
        }

        WatchUi.pushView(menu, new $.PiquetOptionsDelegate(), WatchUi.SLIDE_UP);
    }

    //! Handle the back key being pressed
    public function onBack() as Void
    {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

//! This is the menu input delegate for the main menu of the application
class StaggeringMenuDelegate extends WatchUi.Menu2InputDelegate
{   
    var ParentMenuItem;

    //! Constructor
    public function initialize(item as MenuItem)
    {
        ParentMenuItem = item;
        Menu2InputDelegate.initialize();
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void
    {
        Storage.setValue(ParentMenuItem.getId(), item.getLabel());
        ParentMenuItem.setSubLabel(item.getLabel());

        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

    //! Handle the back key being pressed
    public function onBack() as Void
    {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
