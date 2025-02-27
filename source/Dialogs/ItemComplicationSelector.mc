import Toybox.WatchUi;
import Toybox.Complications;

class ItemComplicationSelector extends WatchUi.MenuItem {
  var ownerItemWeak = null;

  function initialize(complication, ownerItemWeak) {
    self.ownerItemWeak = ownerItemWeak;

    var label = complication.longLabel;
    if (label == null) {
      label = complication.shortLabel;
    }
    if (label == null) {
      label = "<<Unknown id:" + complication.complicationId + ">>";
    }
    MenuItem.initialize(label, null, complication.complicationId, {});
  }

  function onSelectItem() {
    if (ownerItemWeak.stillAlive()) {
      var owner = ownerItemWeak.get();
      owner.updateValue(getId());
      WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
  }
}
