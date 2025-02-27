import Toybox.WatchUi;
import Toybox.Application;

class MenuPresets extends WatchUi.Menu2 {
  function initialize() {
    Menu2.initialize({ :title => Rez.Strings.SubmenuPresets });

    addItem(new ItemPresetSave(weak()));

    var presets = Application.Storage.getValue(Global.PRESETS_KEY);
    if (presets != null) {
      var keys = presets.keys();
      for (var i = 0; i < keys.size(); i++) {
        addItem(new ItemPreset(keys[i], weak()));
      }
    }
  }
}
