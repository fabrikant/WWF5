import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Complications;

class ItemPropertyDataFieldSunEvents extends ItemPropertyAbstract {
  var fieldType = null;

  function initialize(id, label) {
    fieldType = Application.Properties.getValue(id);

    var subLabel = "<<Unknown>>";
    if (fieldType == DataWrapper.THIRD_PARTY_COMPLICATION) {
      var complId = Application.Storage.getValue(id);
      if (complId != null) {
        var compl = Complications.getComplication(complId);
        if (compl instanceof Complications.Complication) {
          if (compl.longLabel != null) {
            subLabel = compl.longLabel;
          } else if (compl.shortLabel != null) {
            subLabel = compl.shortLabel;
          }
        }
      }
    } else {
      subLabel = getCaptionFieldType(fieldType);
    }
    ItemPropertyAbstract.initialize(label, subLabel, id, {});
  }

  function onSelectItem() {
    WatchUi.pushView(
      new MenuPropertySelectorSunEvents(getLabel(), weak()),
      new SimpleMenuDelegate(),
      WatchUi.SLIDE_IMMEDIATE
    );
  }

  function updateValue(newValue) {
    if (newValue == DataWrapper.SUN_EVENTS or newValue == DataWrapper.EMPTY) {
      fieldType = newValue;
      Application.Properties.setValue(getId(), fieldType);
      setSubLabel(getCaptionFieldType(fieldType));
    } else {
      fieldType = DataWrapper.THIRD_PARTY_COMPLICATION;
      Application.Properties.setValue(getId(), fieldType);
      Application.Storage.setValue(getId(), newValue);
    }
  }
}
