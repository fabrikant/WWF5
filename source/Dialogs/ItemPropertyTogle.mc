import Toybox.WatchUi;

class ItemPropertyTogle extends WatchUi.ToggleMenuItem {
  function initialize(id, label) {
    var enabled = Application.Properties.getValue(id);
    ToggleMenuItem.initialize(label, null, id, enabled, {});
  }

  function onSelectItem() {
    Application.Properties.setValue(getId(), isEnabled());
  }
}
