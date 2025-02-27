import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Complications;

class ItemPropertyDataField extends ItemPropertyAbstract {
  var fieldType = null;

  function initialize(id, label) {
    fieldType = Application.Properties.getValue(id);
    var subLabel = getCaptionFieldType(fieldType);
    ItemPropertyAbstract.initialize(label, subLabel, id, {});
  }

  function onSelectItem() {
    WatchUi.pushView(
      new MenuPropertySelecter(getLabel(), weak()),
      new SimpleMenuDelegate(),
      WatchUi.SLIDE_IMMEDIATE
    );
  }

  function updateValue(newValue) {
    fieldType = newValue;
    Application.Properties.setValue(getId(), fieldType);
    setSubLabel(getCaptionFieldType(fieldType));
  }
}
