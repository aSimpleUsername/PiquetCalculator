import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! This is the main view of the application.
//! This view only exists to push the sample menus.
class PiquetCalculatorView extends WatchUi.View {

    //! Constructor
    public function initialize() {
        View.initialize();
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    public function onShow() as Void {
        PiquetCalculatorDelegate.LoadMenu();
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout  
        View.onUpdate(dc);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    public function onHide() as Void {
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This include
    //! loading resources into memory.
    public function updateValues() as Void {
        // find and modify the labels based on what is in storage

        // TODO: Clean this up, left as an example to see how the stored results are used.
        var startTime = findDrawableById("startTime") as Text;
        var endTime = findDrawableById("endTime") as Text;
        var numberOfPers = findDrawableById("numberOfPers") as Text;
        var staggering = findDrawableById("staggering") as Text;

        var prop = Storage.getValue("startTime");
        if (startTime != null && prop instanceof String) {
            startTime.setText(prop);
        }

        prop = Storage.getValue("endTime");
        if (endTime != null && prop instanceof String) {
            endTime.setText(prop);
        }

        prop = Storage.getValue("numberOfPers");
        if (numberOfPers != null && prop instanceof String) {
            numberOfPers.setText(prop);
        }

        // set the color of each Text object
        prop = Storage.getValue("staggering");
        if (staggering != null && prop instanceof String) {
            staggering.setText(prop);
        }
    }
}

