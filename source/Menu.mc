using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Graphics;
using Toybox.Lang;

//GeneralMenu
//	Colors
//		color_font
//		color_font_border
//		color_font_empty_segments
//		color_background
//		color_pattern
//		color_pattern_decorate
//  data_scale
//  data_small
//	Data1
//	Data2
// 	Data3
//  show_connection
//  show_DND
//  Wind speed unit
//  Pressure unit

module Menu {
  //Корневое меню
  function GeneralMenu() {
    var items_props = [];
    //Подменю выбора цветов
    items_props.add({
      :item_class => :SubMenuItem,
      :rez_label => Rez.Strings.SubmenuColors,
      :identifier => :ColorsSubMenu,
      :method => :colorsSubMenu,
    });

    //Выбор показа типов данных по полям
    items_props.add({
      :item_class => :Item,
      :rez_label => Rez.Strings.DataScale,
      :identifier => "data_scale",
      :method => :dataSubMenu,
    });
    items_props.add({
      :item_class => :Item,
      :rez_label => Rez.Strings.SmallField,
      :identifier => "data_small",
      :method => :dataSubMenu,
    });
    items_props.add({
      :item_class => :Item,
      :rez_label => Rez.Strings.Data1,
      :identifier => "data_1",
      :method => :dataSubMenu,
    });
    items_props.add({
      :item_class => :Item,
      :rez_label => Rez.Strings.Data2,
      :identifier => "data_2",
      :method => :dataSubMenu,
    });
    items_props.add({
      :item_class => :Item,
      :rez_label => Rez.Strings.Data3,
      :identifier => "data_3",
      :method => :dataSubMenu,
    });

    //Показ статуса подключения
    items_props.add({
      :item_class => :Item,
      :rez_label => Rez.Strings.show_connection,
      :identifier => "show_connection",
      :method => :connectionSubMenu,
    });

    //Показ статуса DND
    items_props.add({
      :item_class => :TogleItem,
      :rez_label => Rez.Strings.show_DND,
      :identifier => "show_DND",
    });

    //Единицы измерения ветра
    items_props.add({
      :item_class => :Item,
      :rez_label => Rez.Strings.WindSpeedUnit,
      :identifier => "wind_speed_unit",
      :method => :windSpeedUnitsSubmenu,
    });

    //Единицы измерения давления
    items_props.add({
      :item_class => :Item,
      :rez_label => Rez.Strings.PressUnit,
      :identifier => "pressure_unit",
      :method => :pressureUnitsSubmenu,
    });

    var options = { :title => Rez.Strings.MenuHeader, :items => items_props };
    return new SubMenu(options);
  }

  function dataSubMenu() {
    var pattern = {
      DataWrapper.EMPTY => Rez.Strings.FIELD_TYPE_EMPTY,
      DataWrapper.HR => Rez.Strings.FIELD_TYPE_HR,
      DataWrapper.CALORIES => Rez.Strings.FIELD_TYPE_CALORIES,
      DataWrapper.DISTANCE => Rez.Strings.FIELD_TYPE_DISTANCE,
      DataWrapper.STEPS => Rez.Strings.FIELD_TYPE_STEPS,
      DataWrapper.BATTERY => Rez.Strings.FIELD_TYPE_BATTERY,
      DataWrapper.BODY_BATTERY => Rez.Strings.FIELD_TYPE_BODY_BATTERY,
      DataWrapper.RECOVERY_TIME => Rez.Strings.FIELD_TYPE_RECOVERY_TIME,
      DataWrapper.FLOOR => Rez.Strings.FIELD_TYPE_FLOOR,
      DataWrapper.O2 => Rez.Strings.FIELD_TYPE_O2,
      DataWrapper.ELEVATION => Rez.Strings.FIELD_TYPE_ELEVATION,
      DataWrapper.STRESS => Rez.Strings.FIELD_TYPE_STRESS,
      DataWrapper.MOON => Rez.Strings.FIELD_TYPE_MOON,
      DataWrapper.PRESSURE => Rez.Strings.FIELD_TYPE_PRESSURE,
    };
    return pattern;
  }

  //Подменю выбора ед.изм. скорости ветра
  function windSpeedUnitsSubmenu() {
    return {
      Global.UNIT_SPEED_MS => Rez.Strings.SpeedUnitMSec,
      Global.UNIT_SPEED_KMH => Rez.Strings.SpeedUnitKmH,
      Global.UNIT_SPEED_MLH => Rez.Strings.SpeedUnitMileH,
      Global.UNIT_SPEED_FTS => Rez.Strings.SpeedUnitFtSec,
      Global.UNIT_SPEED_BEAUF => Rez.Strings.SpeedUnitBeauf,
      Global.UNIT_SPEED_KNOTS => Rez.Strings.SpeedUnitKnots,
    };
  }

  //Подменю выбора едениц измерения давления
  function pressureUnitsSubmenu() {
    return {
      DataWrapper.UNIT_PRESSURE_MM_HG => Rez.Strings.PressUnitMmHg,
      DataWrapper.UNIT_PRESSURE_PSI => Rez.Strings.PressUnitPsi,
      DataWrapper.UNIT_PRESSURE_INCH_HG => Rez.Strings.PressUnitInchHg,
      DataWrapper.UNIT_PRESSURE_BAR => Rez.Strings.PressUnitBar,
      DataWrapper.UNIT_PRESSURE_KPA => Rez.Strings.PressUnitKPa,
    };
  }

  //Подменю варианта показа значка подключений
  function connectionSubMenu() {
    return {
      Global.BLUETOOTH_SHOW_IF_CONNECT => Rez.Strings.show_if_connect,
      Global.BLUETOOTH_SHOW_IF_DISCONNECT => Rez.Strings.show_if_disconnect,
      Global.BLUETOOTH_HIDE => Rez.Strings.hide,
    };
  }

  //Подменю с настройками цветов
  function colorsSubMenu() {
    var items_props = [];
    items_props.add({
      :item_class => :ColorPropertyItem,
      :rez_label => Rez.Strings.color_font,
      :identifier => "color_font",
      :method => :createColorSelectMenu,
    });
    items_props.add({
      :item_class => :ColorPropertyItem,
      :rez_label => Rez.Strings.color_font_empty_segments,
      :identifier => "color_font_empty_segments",
      :method => :createColorSelectMenu,
    });
    items_props.add({
      :item_class => :ColorPropertyItem,
      :rez_label => Rez.Strings.color_background,
      :identifier => "color_background",
      :method => :createColorSelectMenu,
    });
    items_props.add({
      :item_class => :ColorPropertyItem,
      :rez_label => Rez.Strings.color_pattern,
      :identifier => "color_pattern",
      :method => :createColorSelectMenu,
    });
    items_props.add({
      :item_class => :ColorPropertyItem,
      :rez_label => Rez.Strings.color_pattern_decorate,
      :identifier => "color_pattern_decorate",
      :method => :createColorSelectMenu,
    });

    var options = {
      :title => Rez.Strings.SubmenuColors,
      :items => items_props,
    };
    return new SubMenu(options);
  }

  //Подменю непосредственного выбора цвета
  function createColorSelectMenu(parent_item_week) {
    var items_props = [
      {
        :item_class => :ColorSelectItem,
        :identifier => Graphics.COLOR_TRANSPARENT.toString(),
        :color => Graphics.COLOR_TRANSPARENT,
        :parent_item_week => parent_item_week,
      },
    ];

    var values = [0x00, 0x55, 0xaa, 0xff];
    for (var i = 0; i < values.size(); i++) {
      for (var j = 0; j < values.size(); j++) {
        for (var k = 0; k < values.size(); k++) {
          var color = (values[i] << 16) + (values[j] << 8) + values[k];
          items_props.add({
            :identifier => color.toString(),
            :color => color,
            :parent_item_week => parent_item_week,
          });
        }
      }
    }

    var options = {
      :title => Rez.Strings.SubmenuColors,
      :items => items_props,
      :parent_item_week => parent_item_week,
    };
    return new ColorSelectMenu(options);
  }

  function getSublabel(method_symbol, value) {
    var method = new Lang.Method(Menu, method_symbol);
    var pattern = method.invoke();
    return pattern[value];
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

//*****************************************************************************
//Пункт меню выбора конкретного цвета
//при нажатии значение возвращается в родительский пункт меню
class ColorSelectItem extends ColorPropertyItem {
  var parent_item_week;

  function initialize(options) {
    color = options[:color];
    var label = colorToString(options[:color]);
    var icon = new IconDrawable(color);
    self.parent_item_week = options[:parent_item_week];
    IconMenuItem.initialize(label, null, options[:identifier], icon, {});
  }

  function onSelectItem() {
    if (parent_item_week.stillAlive()) {
      var obj = parent_item_week.get();
      if (obj != null) {
        obj.onSelectSubmenuItem(getId().toNumber());
      }
    }
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
  }
}

//*****************************************************************************
//Пункт меню (ассоциированный со свойством приложения)
//при нажатии открывается подменю класса SelectMenu с элементами класса SelectItem
class Item extends WatchUi.MenuItem {
  var method_symbol;

  function initialize(options) {
    self.method_symbol = options[:method];
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
//Пункт меню (аналог класса Item). Но предназначен для указания цвета
//ассоциирован со свойством приложения
//при нажатии открыватеся подменю выбора цветов
class ColorPropertyItem extends WatchUi.IconMenuItem {
  var method_symbol, color;

  function initialize(options) {
    self.method_symbol = options[:method];
    var label = Application.loadResource(options[:rez_label]);
    color = Application.Properties.getValue(options[:identifier]);
    var icon = new IconDrawable(color);
    IconMenuItem.initialize(
      label,
      colorToString(color),
      options[:identifier],
      icon,
      {}
    );
  }

  function colorToString(color) {
    var res;
    if (color == Graphics.COLOR_TRANSPARENT) {
      res = color.toString();
    } else {
      res = "0x" + color.format("%06X");
    }
    return res;
  }

  function onSelectItem() {
    //Вариант выбора цвета через диалог с палитрой

    // var picker = new ColorPicker(self.weak());
    // WatchUi.pushView(
    //   picker,
    //   new ColorPickerDelegate(picker.weak()),
    //   WatchUi.SLIDE_IMMEDIATE
    // );

    //Вариант выбора цвета через подменю с цветами
    var method = new Lang.Method(Menu, method_symbol);
    var submenu = method.invoke(self.weak());
    WatchUi.pushView(
      submenu,
      new SimpleMenuDelegate(),
      WatchUi.SLIDE_IMMEDIATE
    );
  }

  function onSelectSubmenuItem(newValue) {
    if (newValue instanceof Lang.Number) {
      color = newValue;
    } else {
      color = newValue.toNumber();
    }
    Application.Properties.setValue(getId(), color);
    setSubLabel(colorToString(color));
    setIcon(new IconDrawable(color));
  }
}

//*****************************************************************************
//Пункт меню, при выборе которого откроется другое подменю
//данный пункт не ассоциирован с каким-либо свойством приложения
class SubMenuItem extends WatchUi.MenuItem {
  var method_symbol;

  function initialize(options) {
    self.method_symbol = options[:method];
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

//*****************************************************************************
//Подменю общее. Может содержать пункты выбора значений/цветов, переключатели, а
//также вложенные подменю этого же класса
class SubMenu extends WatchUi.Menu2 {
  function initialize(options) {
    Menu2.initialize({ :title => Application.loadResource(options[:title]) });

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
      }
    }
  }
}

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
//Подменю выбора конкретного цвета
class ColorSelectMenu extends WatchUi.Menu2 {
  function initialize(options) {
    Menu2.initialize({ :title => Application.loadResource(options[:title]) });
    var current_color = null;
    if (options[:parent_item_week].stillAlive()) {
      current_color = options[:parent_item_week].get().color;
    }
    for (var i = 0; i < options[:items].size(); i++) {
      var item_prop = options[:items][i];
      addItem(new ColorSelectItem(item_prop));
      if (item_prop[:color] == current_color) {
        setFocus(i);
      }
    }
  }
}

//*****************************************************************************
//Вспомогательный объект. Формирет Drawable с цветом для размещения цвета на
//пункте меню
class IconDrawable extends WatchUi.Drawable {
  var color;

  function initialize(color) {
    self.color = color;
    var options = {
      :identifier => color,
      :locX => 0,
      :locY => 0,
      :width => 20,
      :height => 20,
      :visible => true,
    };
    Drawable.initialize(options);
  }

  function draw(dc) {
    if (color == Graphics.COLOR_TRANSPARENT) {
      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
      dc.clear();
      dc.setPenWidth(5);
      dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
      dc.drawLine(0, 0, dc.getWidth(), dc.getHeight());
      dc.drawLine(0, dc.getHeight(), dc.getWidth(), 0);
    } else {
      if (color == Graphics.COLOR_BLACK) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
      } else if (color == Graphics.COLOR_WHITE) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
      } else {
        dc.setColor(Graphics.COLOR_WHITE, color);
      }
      dc.clear();
      dc.drawRectangle(0, 0, dc.getWidth(), dc.getHeight());
    }
  }
}

//*****************************************************************************
//Делегат один для всех.
//Вся логика обработки непосредственно в пунктах меню
class SimpleMenuDelegate extends WatchUi.Menu2InputDelegate {
  function initialize() {
    Menu2InputDelegate.initialize();
  }

  function onSelect(item) {
    item.onSelectItem();
  }
}
