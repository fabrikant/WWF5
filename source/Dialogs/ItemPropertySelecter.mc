import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application;
// import Toybox.Complications;

class ItemPropertySelecter extends ItemPropertyAbstract {
  var ownerItemWeak = null;

  function initialize(id, ownerItemWeak) {
    self.ownerItemWeak = ownerItemWeak;
    var label = getCaptionFieldType(id);
    if (label == null) {
      label = "<<Unkown id: " + id + ">>";
    } else if (!(label instanceof Lang.String)) {
      label = Application.loadResource(label);
    }
    ItemPropertyAbstract.initialize(label, "", id, {});
  }

  function onSelectItem() {
    if (ownerItemWeak.stillAlive()) {
      var owner = ownerItemWeak.get();
      owner.updateValue(getId());
      WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
  }
}
