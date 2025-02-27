import Toybox.WatchUi;

class ItemPresetRemove extends WatchUi.MenuItem {
  var ownerItemWeak = null;

  function initialize(ownerItemWeak, label) {
    self.ownerItemWeak = ownerItemWeak;

    MenuItem.initialize(label, null, null, {});
  }

  function onSelectItem() {
    if (ownerItemWeak.stillAlive()) {
      var ownerItem = ownerItemWeak.get();
      Presets.removePreset(ownerItem.getId());
      if (ownerItem.ownerMenuWeak.stillAlive()) {
        var ownerMenu = ownerItem.ownerMenuWeak.get();
        var itemIndex = ownerMenu.findItemById(ownerItem.getId());
        if (itemIndex >= 0) {
          ownerMenu.deleteItem(itemIndex);
        }
      }
    }
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
  }
}
