import Toybox.WatchUi;
import Toybox.Application;

class ItemPropertyBluetoothConnection extends ItemPropertyAbstractList {
  function initialize() {
    var id = "show_connection";
    var label = Rez.Strings.show_connection;
    var value = Application.Properties.getValue(id);
    var values = getList();
    var subLabel = values[value];
    ItemPropertyAbstractList.initialize(label, subLabel, id, {});
  }

  //Подменю выбора ед.изм. скорости ветра
  function getList() {
    return {
      Global.BLUETOOTH_SHOW_IF_CONNECT => Rez.Strings.show_if_connect,
      Global.BLUETOOTH_SHOW_IF_DISCONNECT => Rez.Strings.show_if_disconnect,
      Global.BLUETOOTH_HIDE => Rez.Strings.hide,
    };
  }
}
