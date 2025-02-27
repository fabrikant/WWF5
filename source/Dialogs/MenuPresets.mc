import Toybox.WatchUi;

class MenuPresets extends WatchUi.Menu2 {
  function initialize() {
    Menu2.initialize({ :title => Rez.Strings.SubmenuPresets });

     addItem(new ItemSaveNewPreset());
  }
}
