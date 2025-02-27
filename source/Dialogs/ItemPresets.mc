import Toybox.WatchUi;
import Toybox.Application;

class ItemPresets extends WatchUi.MenuItem {
  function initialize() {
    var label = Rez.Strings.SubmenuPresets;
    MenuItem.initialize(label, null, null, {});
  }

  function onSelectItem() {
    WatchUi.pushView(
      new MenuPresets(),
      new SimpleMenuDelegate(),
      WatchUi.SLIDE_IMMEDIATE
    );
  }
}
