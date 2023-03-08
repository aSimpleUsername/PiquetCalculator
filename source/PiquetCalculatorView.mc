import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! This is the main view of the application.
//! This view only exists to push the sample menus.
class PiquetCalculatorView extends WatchUi.View
{

    //! Constructor
    public function initialize()
    {
        View.initialize();
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    public function onShow() as Void
    {
        PiquetCalculatorDelegate.LoadMenu();
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void
    {
        // Call the parent onUpdate function to redraw the layout  
        View.onUpdate(dc);
    }
}

