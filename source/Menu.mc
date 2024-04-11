using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Complications;
using Toybox.Time;

//GeneralMenu
//	Colors
//		color_image
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
//  data_bottom
//  show_connection
//  show_DND
//  Wind speed unit
//  Pressure unit
//  TimeZoneOffset

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
    //Подменю пресетов
    items_props.add({
      :item_class => :SubMenuItem,
      :rez_label => Rez.Strings.SubmenuPresets,
      :identifier => :PresetsSubMenu,
      :method => :presetsSubMenu,
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
    items_props.add({
      :item_class => :Item,
      :rez_label => Rez.Strings.BottomField,
      :identifier => "data_bottom",
      :method => :dataSubMenuBottom,
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

    //Сдвиг времени для другого часового пояса
    items_props.add({
      :item_class => :PickerItem,
      :rez_label => Rez.Strings.T1TZ,
      :identifier => "T1TZ",
    });

    var options = { :title => Rez.Strings.MenuHeader, :items => items_props };
    return new SubMenu(options);
  }

  function dataSubMenuBottom() {
    var pattern = {
      DataWrapper.EMPTY => Rez.Strings.FIELD_TYPE_EMPTY,
      DataWrapper.DATE_LONG => Rez.Strings.FIELD_TYPE_LONG_DATE,
      DataWrapper.DATE => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_DATE
      ),
      DataWrapper.WEEKDAY_MONTHDAY => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_WEEKDAY_MONTHDAY
      ),
      DataWrapper.CALENDAR_EVENTS => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_CALENDAR_EVENTS
      ),
      DataWrapper.TRAINING_STATUS => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_TRAINING_STATUS
      ),
      DataWrapper.CITY => Rez.Strings.FIELD_TYPE_CITY,
    };
    return pattern;
  }

  function dataSubMenu() {
    var pattern = {
      DataWrapper.EMPTY => Rez.Strings.FIELD_TYPE_EMPTY,
      DataWrapper.HR => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_HEART_RATE
      ),
      DataWrapper.CALORIES_ACTIVE => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_CALORIES
      ),
      DataWrapper.CALORIES_TOTAL => Rez.Strings.FIELD_TYPE_CALORIES_TOTAL,
      DataWrapper.DISTANCE => Rez.Strings.FIELD_TYPE_DISTANCE,
      DataWrapper.STEPS => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_STEPS
      ),
      DataWrapper.BATTERY => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_BATTERY
      ),
      DataWrapper.BODY_BATTERY => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_BODY_BATTERY
      ),
      DataWrapper.RECOVERY_TIME => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_RECOVERY_TIME
      ),
      DataWrapper.FLOOR => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_FLOORS_CLIMBED
      ),
      DataWrapper.O2 => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_PULSE_OX
      ),
      DataWrapper.ALTITUDE => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_ALTITUDE
      ),
      DataWrapper.STRESS => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_STRESS
      ),
      DataWrapper.MOON => Rez.Strings.FIELD_TYPE_MOON,
      DataWrapper.TEMPERATURE => Rez.Strings.FIELD_TYPE_TEMPERATURE,
      DataWrapper.PRESSURE => Rez.Strings.FIELD_TYPE_PRESSURE,
      DataWrapper.RELATIVE_HUMIDITY => Rez.Strings.FIELD_TYPE_RELATIVE_HUMIDITY,
      DataWrapper.PRECIPITATION_CHANCE => Rez.Strings
        .FIELD_TYPE_PRECIPITATION_CHANCE,
      DataWrapper.TIME_ZONE => Rez.Strings.FIELD_TYPE_TIME1,
      DataWrapper.WEIGHT => Rez.Strings.FIELD_TYPE_WEIGHT,
      DataWrapper.WEEKLY_RUN_DISTANCE => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_WEEKLY_RUN_DISTANCE
      ),
      DataWrapper.WEEKLY_BIKE_DISTANCE => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_WEEKLY_BIKE_DISTANCE
      ),
      DataWrapper.VO2_RUN => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_VO2MAX_RUN
      ),
      DataWrapper.VO2_BIKE => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_VO2MAX_BIKE
      ),
      DataWrapper.RESPIRATION_RATE => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_RESPIRATION_RATE
      ),
      DataWrapper.SOLAR_INPUT => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_SOLAR_INPUT
      ),
      DataWrapper.INTENSITY_MINUTES => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_INTENSITY_MINUTES
      ),
      DataWrapper.CALENDAR_EVENTS => getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_CALENDAR_EVENTS
      ),
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

  //подменю пресетов
  function presetsSubMenu() {
    var items_props = [];
    items_props.add({
      :item_class => :CommandItem,
      :rez_label => Rez.Strings.SavePreset,
      :identifier => :savePreset,
      :method => :savePreset,
    });

    var presets = Application.Storage.getValue(Global.PRESETS_STORAGE_KEY);
    if (presets != null) {
      var keys = presets.keys();
      for (var i = 0; i < keys.size(); i++) {
        items_props.add({
          :item_class => :CommandItem,
          :rez_label => presetIdToString(keys[i]),
          :identifier => keys[i],
          :method => :onSelectPreset,
          :method_options => { :id => keys[i] },
        });
      }
    }

    var options = {
      :title => Rez.Strings.SubmenuPresets,
      :items => items_props,
    };
    return new SubMenu(options);
  }

  //Подменю при выборе сохраненного пресета.
  //Выводит подменю с пунктами применить или удалить
  function onSelectPreset(options) {
    var items_props = [];
    items_props.add({
      :item_class => :CommandItem,
      :rez_label => Rez.Strings.ApplyPreset,
      :identifier => :applyPreset,
      :method => :applyPreset,
      :method_options => options,
    });
    items_props.add({
      :item_class => :CommandItem,
      :rez_label => Rez.Strings.RemovePreset,
      :identifier => :removePreset,
      :method => :removePreset,
      :method_options => options,
    });

    var sub_menu_options = {
      :title => presetIdToString(options[:id]),
      :items => items_props,
    };

    WatchUi.pushView(
      new SubMenu(sub_menu_options),
      new SimpleMenuDelegate(),
      WatchUi.SLIDE_IMMEDIATE
    );
  }

  //Подменю с настройками цветов
  function colorsSubMenu() {
    var items_props = [];
    items_props.add({
      :item_class => :ColorPropertyItem,
      :rez_label => Rez.Strings.color_font_image,
      :identifier => "color_image",
      :method => :createColorSelectMenu,
    });
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

  function getNativeComplicationLabel(compl_type) {
    var res = "";
    var compl = Complications.getComplication(new Complications.Id(compl_type));
    if (compl != null) {
      res = compl.longLabel;
      if (res == null) {
        res = compl.shortLabel;
      }
    }
    return res;
  }

  function savePreset(options) {
    var prop_keys = Global.getPropertiesKeys();
    var preset = {};
    for (var i = 0; i < prop_keys.size(); i++) {
      preset[prop_keys[i]] = Application.Properties.getValue(prop_keys[i]);
    }

    var presets = Application.Storage.getValue(Global.PRESETS_STORAGE_KEY);
    if (presets == null) {
      presets = {};
    }
    presets[Time.now().value()] = preset;

    Application.Storage.setValue(Global.PRESETS_STORAGE_KEY, presets);
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
  }

  function applyPreset(options) {
    var presets = Application.Storage.getValue(Global.PRESETS_STORAGE_KEY);
    if (presets == null) {
      return;
    }
    var id = options[:id];
    if (presets.hasKey(id)) {
      var prop_keys = Global.getPropertiesKeys();
      for (var i = 0; i < prop_keys.size(); i++) {
        Application.Properties.setValue(
          prop_keys[i],
          presets[id][prop_keys[i]]
        );
      }
    }
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
  }

  function removePreset(options) {
    var presets = Application.Storage.getValue(Global.PRESETS_STORAGE_KEY);
    if (presets == null) {
      return;
    }
    var id = options[:id];
    if (presets.hasKey(id)) {
      presets.remove(id);
    }
    Application.Storage.setValue(Global.PRESETS_STORAGE_KEY, presets);
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
  }

  function presetIdToString(moment_value) {
    var moment = new Time.Moment(moment_value);
    var info = Time.Gregorian.info(moment, Time.FORMAT_SHORT);
    return Toybox.Lang.format("$1$/$2$/$3$ $4$:$5$:$6$", [
      info.year.format("%04d"),
      info.month.format("%02d"),
      info.day.format("%02d"),
      info.hour.format("%02d"),
      info.min.format("%02d"),
      info.sec.format("%02d"),
    ]);
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
  function initialize(options) {
    var label = Application.loadResource(options[:rez_label]);
    var sublabel = Application.Properties.getValue(options[:identifier]);
    MenuItem.initialize(label, sublabel.toString(), options[:identifier], {});
  }

  function onSelectItem() {
    var charSet = "0123456789-";
    if (getId().equals("keyOW")) {
      charSet = "0123456789abcdef";
    }
    var picker = new StringPicker(self.weak(), charSet);
    WatchUi.pushView(
      picker,
      new StringPickerDelegate(picker),
      WatchUi.SLIDE_IMMEDIATE
    );
  }

  function onSetText(value) {
    setSubLabel(value);
    if (getId().equals("keyOW")) {
      Application.Properties.setValue(getId(), value);
    } else {
      Application.Properties.setValue(getId(), value.toNumber());
    }
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
//Пункт меню команда
class CommandItem extends WatchUi.MenuItem {
  var method_symbol;
  var method_options;

  function initialize(options) {
    self.method_symbol = options[:method];
    self.method_options = options[:method_options];
    System.println("initialize: ");
    System.println("options[:method] " + options[:method]);
    System.println("options[:method_options] " + options[:method_options]);

    var label = "";
    if (options[:rez_label] instanceof Toybox.Lang.String) {
      label = options[:rez_label];
    } else {
      label = Application.loadResource(options[:rez_label]);
    }
    MenuItem.initialize(label, "", options[:identifier], {});
  }

  function onSelectItem() {
    System.println("onSelectItem: " + self.method_options);
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
      :width => 5,
      :height => 5,
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
