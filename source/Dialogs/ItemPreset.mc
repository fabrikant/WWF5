import Toybox.WatchUi;
import Toybox.Application;

class ItemPreset extends WatchUi.MenuItem {
  var ownerMenuWeak = null;

  function initialize(id, ownerMenuWeak) {
    self.ownerMenuWeak = ownerMenuWeak;
    var presets = Application.Storage.getValue(Global.PRESETS_KEY);
    var label = Presets.presetIdToString(id, presets);
    MenuItem.initialize(label, null, id, {});
  }

  function onSelectItem() {
    WatchUi.pushView(
      new MenuPresetCommands(weak()),
      new SimpleMenuDelegate(),
      WatchUi.SLIDE_IMMEDIATE
    );
  }
}
