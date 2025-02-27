import Toybox.WatchUi;

class ItemSubMenuColors extends WatchUi.MenuItem {
  function initialize() {
    MenuItem.initialize(Rez.Strings.SubmenuColors, null, null, {});
  }

  function onSelectItem() {
    WatchUi.pushView(
      new MenuColorsItems(),
      new SimpleMenuDelegate(),
      WatchUi.SLIDE_IMMEDIATE
    );
  }
}
