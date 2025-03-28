import Toybox.WatchUi;
import Toybox.System;
import Toybox.Complications;

class WWF5Delegate extends WatchUi.WatchFaceDelegate {
  function onPowerBudgetExceeded(powerInfo) {
    logger.debug("onPowerBudgetExceeded");
    logger.debug("TimeAverage: " + powerInfo.executionTimeAverage);
    logger.debug("TimeLimit: " + powerInfo.executionTimeLimit);
  }

  function onPress(clickEvent) {
    var layers = getApp().watch_view.getLayers();
    for (var i = 0; i < layers.size(); i++) {
      if (layers[i].checkOnPress(clickEvent)) {
        if (layers[i].compl_id instanceof Complications.Id) {
          var compl_id = layers[i].compl_id;
          if (
            compl_id.getType() ==
            Complications.COMPLICATION_TYPE_CURRENT_WEATHER
          ) {
            //try to open RoseOfWind
            var iter = Complications.getComplications();
            var compl = iter.next();
            while (compl != null) {
              if (compl.shortLabel != null && compl.longLabel != null) {
                if (
                  compl.shortLabel.equals("owm_key") &&
                  compl.longLabel.equals("RoseOfWind")
                ) {
                  if (compl.value != null) {
                    if (!compl.value.equals("")) {
                      if (compl.complicationId != null) {
                        compl_id = compl.complicationId;
                      }
                    }
                  }
                  break;
                }
              }
              compl = iter.next();
            }
          }

          try {
            Complications.exitTo(compl_id);
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
