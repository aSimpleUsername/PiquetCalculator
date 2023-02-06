import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

//! Picker that allows the user to choose a single number
class NumberPicker extends WatchUi.Picker
{

    var MenuID;

    //! Constructor
    public function initialize(id as String)
    {
        var factories = new Array<PickerFactory>[1];
        factories[0] = new $.NumberFactory(1, 99, 1, {});

        var title = new WatchUi.Text({:text=>id, :locX=>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, :color=>Graphics.COLOR_WHITE});

        var defaults = new Array<Number>[1];

        // -1 so the index matches the value, check that it can't go negative
        defaults[0] = Storage.getValue(id) > 0 ? Storage.getValue(id) - 1 : 0;

        Picker.initialize({:title=>title, :pattern=>factories, :defaults=>defaults});
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void
    {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

//! Responds to a number picker selection or cancellation
class NumberPickerDelegate extends WatchUi.PickerDelegate
{
    var ParentMenuItem;

    //! Constructor
    public function initialize(item as MenuItem)
    {
        PickerDelegate.initialize();
        ParentMenuItem = item;
    }

    //! Handle a cancel event from the picker
    //! @return true if handled, false otherwise
    public function onCancel() as Boolean
    {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    //! Handle a confirm event from the picker
    //! @param values The values chosen in the picker
    //! @return true if handled, false otherwise
    public function onAccept(values as Array<Number?>) as Boolean
    {
        // We only have one value to consider
        var value = values[0];
        if (value != null)
        {
            Storage.setValue(ParentMenuItem.getId(), value);

            ParentMenuItem.setSubLabel(value.format("%d"));
        }        

        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}
