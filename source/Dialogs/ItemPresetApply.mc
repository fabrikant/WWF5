import Toybox.WatchUi;

class ItemPresetApply extends WatchUi.MenuItem {
  var ownerItemWeak = null;

  function initialize(ownerItemWeak, label) {
    self.ownerItemWeak = ownerItemWeak;

    MenuItem.initialize(label, null, null, {});
  }

  function onSelectItem() {
    if (ownerItemWeak.stillAlive()) {
      var ownerItem = ownerItemWeak.get();
      Presets.applyPreset(ownerItem.getId());
    }
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
  }
}
