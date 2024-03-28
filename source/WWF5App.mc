import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class WWF5App extends Application.AppBase {

    var system_complications;

    function initialize() {
        AppBase.initialize();
        system_complications = Global.getSystemComplications();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new WWF5View() ] as Array<Views or InputDelegates>;
    }

    function getSettingsView(){
		return [Menu.GeneralMenu(), new SimpleMenuDelegate()];
	}
}

function getApp() as WWF5App {
    return Application.getApp() as WWF5App;
}