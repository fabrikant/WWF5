import Toybox.WatchUi;
import Toybox.System;
import Toybox.Complications;

class WWF5Delegate extends WatchUi.WatchFaceDelegate {
  function onPowerBudgetExceeded(powerInfo) {
    System.println("onPowerBudgetExceeded");
    System.println("TimeAverage: " + powerInfo.executionTimeAverage);
    System.println("TimeLimit: " + powerInfo.executionTimeLimit);
  }

  function onPress(clickEvent) {
    var layers = getApp().watch_view.getLayers();
    for (var i = 0; i < layers.size(); i++) {
      if (layers[i].checkOnPress(clickEvent)) {
        if (layers[i].compl_id instanceof Complications.Id) {
          try {
            Complications.exitTo(layers[i].compl_id);
            return true;
          } catch (ex) {
            return false;
          }
        }
        return false;
      }
    }
  }
}
