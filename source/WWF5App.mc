import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Complications;

(:background)
class WWF5App extends Application.AppBase {
  var watch_view;

  function initialize() {
    AppBase.initialize();
  }

  // onStart() is called on application start up
  function onStart(state as Dictionary?) as Void {}

  // onStop() is called when your application is exiting
  function onStop(state as Dictionary?) as Void {}

  // Return the initial view of your application here
  function getInitialView() as Array<Views or InputDelegates>? {
    watch_view = new WWF5View();
    return [watch_view, new WWF5Delegate()] as Array<Views or InputDelegates>;
  }

  function getSettingsView() {
    return [Menu.GeneralMenu(), new SimpleMenuDelegate()];
  }

  ///////////////////////////////////////////////////////////////////////////
  // Background
  function onBackgroundData(data) {
    if (data != null) {
      Application.Storage.setValue(Global.CURRENT_WEATHER_KEY, data);
    }
    registerEvents();
  }

  function registerEvents() {
    var kewOw = Application.Properties.getValue("owm_key");
    if (kewOw.equals("")) {
      //try to get owm api key from RoseOfWind
      var iter = Complications.getComplications();
      var compl = iter.next();
      while (compl != null) {
        if (compl.shortLabel != null) {
          if (compl.shortLabel.equals("owm_key")) {
            if (compl.value != null) {
              if (!compl.value.equals("")) {
                kewOw = compl.value;
                Application.Properties.setValue("owm_key", kewOw);
                break;
              }
            }
          }
        }
        compl = iter.next();
      }
      if (kewOw.equals("")) {
        return;
      }
    }
    var registeredTime = Background.getTemporalEventRegisteredTime();
    if (registeredTime != null) {
      return;
    }
    var lastTime = Background.getLastTemporalEventTime();
    var duration = new Time.Duration(600);
    var now = Time.now();
    if (lastTime == null) {
      Background.registerForTemporalEvent(now);
    } else {
      if (now.greaterThan(lastTime.add(duration))) {
        Background.registerForTemporalEvent(now);
      } else {
        var nextTime = lastTime.add(duration);
        Background.registerForTemporalEvent(nextTime);
      }
    }
  }

  function getServiceDelegate() {
    return [new BackgroundService()];
  }
}

function getApp() as WWF5App {
  return Application.getApp() as WWF5App;
}
