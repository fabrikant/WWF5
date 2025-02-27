import Toybox.WatchUi;
import Toybox.Application;

class ItemPropertyPressure extends ItemPropertyAbstractList {
  function initialize() {
    var id = "pressure_unit";
    var label = Rez.Strings.PressUnit;
    var value = Application.Properties.getValue(id);
    var values = getList();
    var subLabel = values[value];
    ItemPropertyAbstractList.initialize(label, subLabel, id, {});
  }

  //Подменю выбора ед.изм. скорости ветра
  function getList() {
    return {
      DataWrapper.UNIT_PRESSURE_MM_HG => Rez.Strings.PressUnitMmHg,
      DataWrapper.UNIT_PRESSURE_PSI => Rez.Strings.PressUnitPsi,
      DataWrapper.UNIT_PRESSURE_INCH_HG => Rez.Strings.PressUnitInchHg,
      DataWrapper.UNIT_PRESSURE_BAR => Rez.Strings.PressUnitBar,
      DataWrapper.UNIT_PRESSURE_KPA => Rez.Strings.PressUnitKPa,
    };
  }
}
