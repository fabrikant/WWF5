import Toybox.WatchUi;

class MenuPresetCommands extends WatchUi.Menu2 {
  function initialize(ownerItemWeak) {
    Menu2.initialize({ :title => Rez.Strings.SubmenuPresets });

    addItem(new ItemPresetApply(ownerItemWeak, Rez.Strings.ApplyPreset));
    addItem(new ItemPresetRemove(ownerItemWeak, Rez.Strings.RemovePreset));
  }
}
