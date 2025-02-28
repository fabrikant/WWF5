import Toybox.WatchUi;

class ItemPresetRename extends WatchUi.MenuItem {
  var ownerItemWeak = null;

  function initialize(ownerItemWeak, label) {
    self.ownerItemWeak = ownerItemWeak;

    MenuItem.initialize(label, null, null, {});
  }

  function onSelectItem() {
    if (ownerItemWeak.stillAlive()) {
      var ownerItem = ownerItemWeak.get();
      WatchUi.pushView(
        new WatchUi.TextPicker(ownerItem.getLabel()),
        new TextDelegate(self.weak()),
        WatchUi.SLIDE_IMMEDIATE
      );
    }
  }

  function onSetText(text) {
    if (ownerItemWeak.stillAlive()) {
      var ownerItem = ownerItemWeak.get();
      Presets.renamePreset(ownerItem.getId(), text);
      ownerItem.setLabel(text);
    }
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
  }
}
