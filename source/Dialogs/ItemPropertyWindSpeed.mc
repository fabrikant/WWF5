import Toybox.WatchUi;
import Toybox.Application;

class ItemPropertyWindSpeed extends ItemPropertyAbstractList {
  function initialize() {
    var id = "wind_speed_unit";
    var label = Rez.Strings.WindSpeedUnit;
    var value = Application.Properties.getValue(id);
    var values = getList();
    logger.debug(values);
    var subLabel = values[value];
    ItemPropertyAbstractList.initialize(label, subLabel, id, {});
  }


  //Подменю выбора ед.изм. скорости ветра
  function getList() {
    return {
      Global.UNIT_SPEED_MS => Rez.Strings.SpeedUnitMSec,
      Global.UNIT_SPEED_KMH => Rez.Strings.SpeedUnitKmH,
      Global.UNIT_SPEED_MLH => Rez.Strings.SpeedUnitMileH,
      Global.UNIT_SPEED_FTS => Rez.Strings.SpeedUnitFtSec,
      Global.UNIT_SPEED_BEAUF => Rez.Strings.SpeedUnitBeauf,
      Global.UNIT_SPEED_KNOTS => Rez.Strings.SpeedUnitKnots,
    };
  }
}
