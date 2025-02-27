import Toybox.WatchUi;
import Toybox.Application;

class ItemPresetSave extends WatchUi.MenuItem {
  var ownerMenuWeak = null;

  function initialize(ownerMenuWeak) {
    self.ownerMenuWeak = ownerMenuWeak;
    var label = Rez.Strings.SavePreset;
    MenuItem.initialize(label, null, null, {});
  }

  function onSelectItem() {
    var presetId = Presets.savePreset();
    if (ownerMenuWeak.stillAlive()) {
      var menu = ownerMenuWeak.get();
      menu.addItem(new ItemPreset(presetId, ownerMenuWeak));
    }
  }
}
