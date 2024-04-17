import Toybox.Application;
import Toybox.WatchUi;
import Toybox.Lang;

//*****************************************************************************
//Подменю выбора конкретного значения
class SelectMenu extends WatchUi.Menu2 {
  function initialize(options) {
    Menu2.initialize({ :title => options[:title] });
    var property_value = Application.Properties.getValue(options[:prop_name]);
    var storage_value = Application.Storage.getValue(options[:prop_name]);
    var pattern = (new Lang.Method(Menu, options[:method_symbol])).invoke();
    var keys = pattern.keys();
    for (var i = 0; i < keys.size(); i++) {
      addItem(
        new SelectItem(keys[i], pattern[keys[i]], options[:parent_item_week])
      );
      if (property_value == keys[i]) {
        setFocus(i);
      } else if (storage_value != null) {
        if (storage_value.equals(keys[i])) {
          setFocus(i);
        }
      }
    }
  }
}

//*****************************************************************************
//Пункт меню переключатель
class TogleItem extends WatchUi.ToggleMenuItem {
  function initialize(options) {
    var label = Application.loadResource(options[:rez_label]);
    var enabled = Application.Properties.getValue(options[:identifier]);
    ToggleMenuItem.initialize(label, null, options[:identifier], enabled, {});
  }

  function onSelectItem() {
    Application.Properties.setValue(getId(), isEnabled());
  }
}

//*****************************************************************************
//Пункт меню ввода текста
class PickerItem extends WatchUi.MenuItem {
  var char_set;
  var method_symbol;
  var method_options;

  function initialize(options) {
    self.char_set = options[:char_set];
    self.method_symbol = options[:method_symbol];
    self.method_options = options[:method_options];
    var label = Application.loadResource(options[:rez_label]);
    var sublabel = "";
    if (options[:sublabel] instanceof Lang.String) {
      sublabel = options[:sublabel];
    } else {
      if (!(options[:identifier] instanceof Lang.Symbol)) {
        sublabel = Application.Properties.getValue(options[:identifier]);
        if (sublabel != null) {
          sublabel = sublabel.toString();
        }
      }
    }
    MenuItem.initialize(label, sublabel, options[:identifier], {});
  }

  function onSelectItem() {
    WatchUi.pushView(
      new WatchUi.TextPicker(getSubLabel()),
      new TextDelegate(self.weak()),
      WatchUi.SLIDE_IMMEDIATE
    );
  }

  function onSetText(value) {
    if (method_symbol == null) {
      setSubLabel(value);
      var old_value = Application.Properties.getValue(getId());
      if (old_value instanceof Lang.String) {
        Application.Properties.setValue(getId(), value);
      } else if (old_value instanceof Lang.Number) {
        Application.Properties.setValue(getId(), value.toNumber());
      } else if (old_value instanceof Lang.Lang) {
        Application.Properties.setValue(getId(), value.toLong());
      } else if (old_value instanceof Lang.Float) {
        Application.Properties.setValue(getId(), value.toFloat());
      } else if (old_value instanceof Lang.Double) {
        Application.Properties.setValue(getId(), value.toDouble());
      }
    } else {
      var method = new Lang.Method(Menu, method_symbol);
      if (method_options instanceof Lang.Dictionary) {
        method_options[:value] = value;
      } else {
        method_options = { :value => value };
      }
      method.invoke(method_options);
    }
  }
}

//*****************************************************************************
//Пункт меню команда
class CommandItem extends WatchUi.MenuItem {
  var method_symbol;
  var method_options;

  function initialize(options) {
    self.method_symbol = options[:method_symbol];
    self.method_options = options[:method_options];

    var label = "";
    if (options[:rez_label] instanceof Toybox.Lang.String) {
      label = options[:rez_label];
    } else {
      label = Application.loadResource(options[:rez_label]);
    }
    var sublabel = "";
    if (options[:sublabel] instanceof Toybox.Lang.String) {
      sublabel = options[:sublabel];
    }
    MenuItem.initialize(label, sublabel, options[:identifier], {});
  }

  function onSelectItem() {
    var method = new Lang.Method(Menu, method_symbol);
    method.invoke(self.method_options);
  }
}

//*****************************************************************************
//Пункт меню (ассоциированный со свойством приложения)
//при нажатии открывается подменю класса SelectMenu с элементами класса SelectItem
class Item extends WatchUi.MenuItem {
  var method_symbol;

  function initialize(options) {
    self.method_symbol = options[:method_symbol];
    var label = Application.loadResource(options[:rez_label]);
    var value = Application.Properties.getValue(options[:identifier]);
    var sublabel = Menu.getSublabel(method_symbol, value);
    MenuItem.initialize(label, sublabel, options[:identifier], {});
  }

  function onSelectItem() {
    var options = {
      :title => getLabel(),
      :method_symbol => method_symbol,
      :prop_name => getId(),
      :parent_item_week => self.weak(),
    };
    var submenu = new SelectMenu(options);
    WatchUi.pushView(
      submenu,
      new SimpleMenuDelegate(),
      WatchUi.SLIDE_IMMEDIATE
    );
  }

  function onSelectSubmenuItem(newValue) {
    Application.Properties.setValue(getId(), newValue);
    setSubLabel(Menu.getSublabel(method_symbol, newValue));
  }
}

//*****************************************************************************
//Пункт меню выбора конкретного значения
//при нажатии значение возвращается в родительский пункт меню
class SelectItem extends WatchUi.MenuItem {
  var callbackWeak;

  function initialize(identifier, resLabel, callbackWeak) {
    self.callbackWeak = callbackWeak;
    if (resLabel instanceof Lang.String) {
      MenuItem.initialize(resLabel, null, identifier, {});
    } else {
      MenuItem.initialize(
        Application.loadResource(resLabel),
        null,
        identifier,
        {}
      );
    }
  }

  function onSelectItem() {
    if (callbackWeak.stillAlive()) {
      var obj = callbackWeak.get();
      if (obj != null) {
        obj.onSelectSubmenuItem(getId());
      }
    }
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
  }
}
