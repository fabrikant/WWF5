import Toybox.WatchUi;
import Toybox.Application;

class ItemPropertyAbstractList extends WatchUi.MenuItem {
  function initialize(label, subLabel, id, options) {
    MenuItem.initialize(label, subLabel, id, options);
  }

  function onSelectItem() {
    WatchUi.pushView(
      new MenuListSelector(getLabel(), weak(), getList()),
      new SimpleMenuDelegate(),
      WatchUi.SLIDE_IMMEDIATE
    );
  }

  function updateValue(newValue) {
    Application.Properties.setValue(getId(), newValue);
    var values = getList();
    setSubLabel(Application.loadResource(values[newValue]));
  }
}
