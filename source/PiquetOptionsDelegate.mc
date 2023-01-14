
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

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
                // TODO: Doesn't work, reference Picker/NumberPicker Sample project
                new $.NumberFactory(1, 99, 1, {});
                break;
            default:
                WatchUi.requestUpdate();
        }

    }

    //! Handle the back key being pressed
    public function onBack() as Void
    {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

//! This is the menu input delegate shared by all the basic sub-menus in the application
class Menu2SampleSubMenuDelegate extends WatchUi.Menu2InputDelegate
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
        // For IconMenuItems, we will change to the next icon state.
        // This demonstrates a custom toggle operation using icons.
        // Static icons can also be used in this layout.
        WatchUi.requestUpdate();
    }

    //! Handle the back key being pressed
    public function onBack() as Void 
    {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    //! Handle the done item being selected
    public function onDone() as Void
    {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
