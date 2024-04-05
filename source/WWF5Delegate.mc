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
    try {
      Complications.exitTo(
        new Complications.Id(Complications.COMPLICATION_TYPE_CURRENT_WEATHER)
      );
      return true;
    } catch (ex) {
      return false;
    }
  }
}
