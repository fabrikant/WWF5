import Toybox.WatchUi;
import Toybox.Complications;

class MenuPropertySelectorSunEvents extends WatchUi.Menu2 {
  var ownerItemWeak;

  function initialize(title, ownerItemWeak) {
    self.ownerItemWeak = ownerItemWeak;
    Menu2.initialize({ :title => title });

    addItem(new ItemPropertySelector(DataWrapper.SUN_EVENTS, ownerItemWeak));

    var iterator = Complications.getComplications();
    var complication = iterator.next();
    while (complication != null) {
      var type = complication.getType();
      if (type != null and type == Complications.COMPLICATION_TYPE_INVALID) {
        if (
          complication.shortLabel.equals("owm_key") &&
          complication.longLabel.equals("RoseOfWind")
        ) {
          complication = iterator.next();
          continue;
        }

        addItem(new ItemComplicationSelector(complication, ownerItemWeak));
      }
      complication = iterator.next();
    }

    if (ownerItemWeak.stillAlive()) {
      var owner = ownerItemWeak.get();
      if (owner.fieldType == DataWrapper.THIRD_PARTY_COMPLICATION) {
        var ownerComplId = Application.Storage.getValue(owner.getId());
        var index = findItemById(ownerComplId);
        if (index >= 0) {
          setFocus(index);
        }
      }
    }
  }
}
