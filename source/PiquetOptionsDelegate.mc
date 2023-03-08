
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
                var staggeringMenu = new WatchUi.Menu2({});
                // Add menu items for demonstrating toggles, checkbox and icon menu items
                staggeringMenu.addItem(new WatchUi.MenuItem("Single Staggered", null, "singleStaggered", null));
                staggeringMenu.addItem(new WatchUi.MenuItem("Double Staggered", null, "doubleStaggered", null));
                WatchUi.pushView(staggeringMenu, new $.StaggeringMenuDelegate(item), WatchUi.SLIDE_UP);
                break;
            case "calculate":
                var calculateList = new WatchUi.Menu2({:title=> "Piquet List"});
                WatchUi.pushView(calculateList, new $.CalculateDelegate(calculateList), WatchUi.SLIDE_UP);
                break;
            default:
                WatchUi.requestUpdate();
        }
    }

    //! Handle the back key being pressed
    public function onBack() as Void
    {
        System.exit();
        //WatchUi.popView(WatchUi.SLIDE_DOWN);
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

//! This is the menu input delegate for the main menu of the application
class CalculateDelegate extends WatchUi.Menu2InputDelegate
{   
    var menu;

    //! Constructor
    public function initialize(menuObj as Menu2)
    {
        menu = menuObj;
        calculate();

        Menu2InputDelegate.initialize();
    }

    //! Handle the back key being pressed
    public function onBack() as Void
    {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    private function calculate()
    {
        // Generate a new Menu with a drawable Title
        
        var numberOfPers = Storage.getValue("numberOfPers").toNumber();
        var isDoubleStaggered = Storage.getValue("staggering").equals("Double Staggered") as Boolean;

        //TODO: Remove constant $.FACTORY_COUNT_24_HOUR
        var storedStartTime = TimePicker.splitStoredTime($.FACTORY_COUNT_24_HOUR, Storage.getValue("startTime"));
        var storedEndTime = TimePicker.splitStoredTime($.FACTORY_COUNT_24_HOUR, Storage.getValue("endTime"));

        var startHour = storedStartTime[0].toNumber();
        var startMinute = storedStartTime[1].toNumber();
        var endHour = storedEndTime[0].toNumber();
        var endMinute = storedEndTime[1].toNumber();
        
        var hourDifference = endHour - startHour;
        var minuteDifference = endMinute - startMinute;

        if(hourDifference < 0)
        {
            hourDifference += 24;
        }
        
        if(minuteDifference < 0)
        {
            hourDifference--;
            minuteDifference += 60;
        }
        
        var piquetTime = ((hourDifference + (minuteDifference / 60.0f)) / numberOfPers) * 60;
        var piquetTimeRounded = Math.round(piquetTime);
        
        var tempStartHour = startHour;
        var tempStartMinute = startMinute;
        var tempEndHour = startHour;
        var tempEndMinute = startMinute;

        if(isDoubleStaggered)
        {
            numberOfPers += 1;
            piquetTime *= 2;
        }

        for(var i=0; i<numberOfPers; ++i)
        {
            var serial = i+1;

            tempEndMinute += piquetTime;

            // First shift is only half shift
            if(i == 0 && isDoubleStaggered)
            {
                tempEndMinute -= piquetTime/2;
            }            
            
            while(tempEndMinute >= 60)
            {
                tempEndMinute -= 60;
                tempEndHour++;
            }
            
            if(tempEndHour >= 24)
            {
                tempEndHour -= 24;
            }

            if(i == numberOfPers-1)
            {
                tempEndHour = storedEndTime[0].toNumber();
                tempEndMinute = storedEndTime[1].toNumber();
                
                if(isDoubleStaggered)
                {
                    serial = 1;
                }
            }
            
            menu.addItem(new WatchUi.MenuItem(serial + ". " + tempStartHour.format("%02d") + ":" + tempStartMinute.format("%02d") + " - " +
                tempEndHour.format("%02d") + ":" + tempEndMinute.format("%02d"), null, "serial" + serial, null));

            tempStartHour = tempEndHour;
            tempStartMinute = tempEndMinute;

            if(isDoubleStaggered)
            {
                tempStartMinute -= piquetTime / 2;
                tempEndMinute -= piquetTime / 2;

                while(tempStartMinute < 0)
                {
                    tempStartMinute += 60;
                    tempStartHour--;
                }
                
                if(tempStartHour < 0)
                {
                    tempStartHour += 24;
                }
            }            
        }
        menu.setTitle(piquetTime.format("%d") + "min Each");
    }
}
