import Toybox.Application;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

//*****************************************************************************
//Подменю общее. Может содержать пункты выбора значений/цветов, переключатели, а
//также вложенные подменю как экземпляры класса SubMenuItem
class SubMenu extends WatchUi.Menu2 {
  function initialize(options) {
    var title = "";
    if (options[:title] instanceof Toybox.Lang.String) {
      title = options[:title];
    } else {
      title = Application.loadResource(options[:title]);
    }
    Menu2.initialize({ :title => title });

    for (var i = 0; i < options[:items].size(); i++) {
      var item_prop = options[:items][i];
      if (item_prop[:item_class] == :SubMenuItem) {
        addItem(new SubMenuItem(item_prop));
      } else if (item_prop[:item_class] == :ColorPropertyItem) {
        addItem(new ColorPropertyItem(item_prop));
      } else if (item_prop[:item_class] == :Item) {
        addItem(new Item(item_prop));
      } else if (item_prop[:item_class] == :TogleItem) {
        addItem(new TogleItem(item_prop));
      } else if (item_prop[:item_class] == :PickerItem) {
        addItem(new PickerItem(item_prop));
      } else if (item_prop[:item_class] == :CommandItem) {
        addItem(new CommandItem(item_prop));
      }
    }
  }
}

//*****************************************************************************
//Пункт меню, при выборе которого откроется другое подменю
//данный пункт не ассоциирован с каким-либо свойством приложения
class SubMenuItem extends WatchUi.MenuItem {
  var method_symbol;

  function initialize(options) {
    self.method_symbol = options[:method_symbol];
    var label = Application.loadResource(options[:rez_label]);
    MenuItem.initialize(label, "", options[:identifier], {});
  }

  function onSelectItem() {
    var method = new Lang.Method(Menu, method_symbol);
    var submenu = method.invoke();
    WatchUi.pushView(
      submenu,
      new SimpleMenuDelegate(),
      WatchUi.SLIDE_IMMEDIATE
    );
  }
}
