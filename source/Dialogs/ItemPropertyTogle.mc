import Toybox.WatchUi;

class ItemPropertyTogle extends WatchUi.ToggleMenuItem {
  var subTrue, subFalse;

  function initialize(id, label, subTrue, subFalse) {
    self.subTrue = subTrue;
    self.subFalse = subFalse;
    var enabled = Application.Properties.getValue(id);
    ToggleMenuItem.initialize(label, null, id, enabled, {});

    setSubLabel({ :enabled => subTrue, :disabled => subFalse });
  }

  function onSelectItem() {
    Application.Properties.setValue(getId(), isEnabled());
    setSubLabel({ :enabled => subTrue, :disabled => subFalse });
  }
}
