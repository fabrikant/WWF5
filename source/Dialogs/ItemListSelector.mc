import Toybox.WatchUi;

class ItemListSelector extends WatchUi.MenuItem{
    var ownerItemWeak = null;
    function initialize(id, label, ownerItemWeak){
        self.ownerItemWeak = ownerItemWeak;
        MenuItem.initialize(label, null, id, {});
    }

    function onSelectItem() {
    if (ownerItemWeak.stillAlive()) {
      var owner = ownerItemWeak.get();
      owner.updateValue(getId());
      WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
  }
}