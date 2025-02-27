import Toybox.WatchUi;
import Toybox.Application;

class ItemPropertyText extends ItemPropertyAbstract {
  function initialize(id, label) {
    var subLabel = Application.Properties.getValue(id);
    ItemPropertyAbstract.initialize(label, subLabel.toString(), id, {});
  }

  function onSelectItem() {
    WatchUi.pushView(
      new WatchUi.TextPicker(getSubLabel()),
      new TextDelegate(self.weak()),
      WatchUi.SLIDE_IMMEDIATE
    );
  }

  function onSetText(value) {
    setSubLabel(value);
    var old_value = Application.Properties.getValue(getId());
    if (old_value instanceof Lang.String) {
      Application.Properties.setValue(getId(), value);
    } else if (old_value instanceof Lang.Number) {
      Application.Properties.setValue(getId(), value.toNumber());
    } else if (old_value instanceof Lang.Long) {
      Application.Properties.setValue(getId(), value.toLong());
    } else if (old_value instanceof Lang.Float) {
      Application.Properties.setValue(getId(), value.toFloat());
    } else if (old_value instanceof Lang.Double) {
      Application.Properties.setValue(getId(), value.toDouble());
    }
  }
}
