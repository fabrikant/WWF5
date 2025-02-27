import Toybox.WatchUi;
import Toybox.Application;

class ItemSaveNewPreset extends WatchUi.MenuItem {
  function initialize() {
    var label = Rez.Strings.SavePreset;
    MenuItem.initialize(label, null, null, {});
  }

  function onSelectItem() {}
}
