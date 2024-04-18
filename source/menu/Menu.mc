import Toybox.Application;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Complications;
import Toybox.Time;

//GeneralMenu
//  Presets
//    Save new preset
//    Preset1
//      Apply
//      Remove
//    ....
//    PresetN
//	Colors
//		c_image
//		c_font
//		color_font_border
//		c_es
//		c_bgnd
//		c_patt
//		c_patt_d
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
    Presets.generatePresetsStorage();

    var items_props = [];
    //Подменю пресетов
    items_props.add({
      :item_class => :SubMenuItem,
      :rez_label => Rez.Strings.SubmenuPresets,
      :identifier => :PresetsSubMenu,
      :method_symbol => :presetsSubMenu,
    });
    //Подменю выбора цветов
    items_props.add({
      :item_class => :SubMenuItem,
      :rez_label => Rez.Strings.SubmenuColors,
      :identifier => :ColorsSubMenu,
      :method_symbol => :colorsSubMenu,
    });
    //Выбор показа типов данных по полям
    items_props.add({
      :item_class => :Item,
      :rez_label => Rez.Strings.DataScale,
      :identifier => "data_scale",
      :method_symbol => :dataSubMenu,
    });
    items_props.add({
      :item_class => :Item,
      :rez_label => Rez.Strings.SmallField,
      :identifier => "data_small",
      :method_symbol => :dataSubMenu,
    });
    items_props.add({
      :item_class => :Item,
      :rez_label => Rez.Strings.Data1,
      :identifier => "data_1",
      :method_symbol => :dataSubMenu,
    });
    items_props.add({
      :item_class => :Item,
      :rez_label => Rez.Strings.Data2,
      :identifier => "data_2",
      :method_symbol => :dataSubMenu,
    });
    items_props.add({
      :item_class => :Item,
      :rez_label => Rez.Strings.Data3,
      :identifier => "data_3",
      :method_symbol => :dataSubMenu,
    });
    items_props.add({
      :item_class => :Item,
      :rez_label => Rez.Strings.BottomField,
      :identifier => "data_bottom",
      :method_symbol => :dataSubMenuBottom,
    });

    //Показ статуса подключения
    items_props.add({
      :item_class => :Item,
      :rez_label => Rez.Strings.show_connection,
      :identifier => "show_connection",
      :method_symbol => :connectionSubMenu,
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
      :method_symbol => :windSpeedUnitsSubmenu,
    });

    //Единицы измерения давления
    items_props.add({
      :item_class => :Item,
      :rez_label => Rez.Strings.PressUnit,
      :identifier => "pressure_unit",
      :method_symbol => :pressureUnitsSubmenu,
    });

    //Сдвиг времени для другого часового пояса
    items_props.add({
      :item_class => :PickerItem,
      :rez_label => Rez.Strings.T1TZ,
      :identifier => "T1TZ",
    });

    //Показать Источник данных о погоде
    items_props.add({
      :item_class => :TogleItem,
      :rez_label => Rez.Strings.show_w_source,
      :identifier => "show_w_source",
    });

    //Ключ  API openweathermap.org
    items_props.add({
      :item_class => :PickerItem,
      :rez_label => Rez.Strings.owm_key,
      :identifier => "owm_key",
    });

    var options = { :title => Rez.Strings.MenuHeader, :items => items_props };
    return new SubMenu(options);
  }

  function dataSubMenuBottom() {
    var pattern = {
      DataWrapper.EMPTY => Rez.Strings.FIELD_TYPE_EMPTY,
      DataWrapper.DATE_LONG => Rez.Strings.FIELD_TYPE_LONG_DATE,
      DataWrapper.CITY => Rez.Strings.FIELD_TYPE_CITY,
    };

    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.DATE,
      Complications.COMPLICATION_TYPE_DATE
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.WEEKDAY_MONTHDAY,
      Complications.COMPLICATION_TYPE_WEEKDAY_MONTHDAY
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.CALENDAR_EVENTS,
      Complications.COMPLICATION_TYPE_CALENDAR_EVENTS
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.TRAINING_STATUS,
      Complications.COMPLICATION_TYPE_TRAINING_STATUS
    );

    return pattern;
  }

  function dataSubMenu() {
    var pattern = {
      DataWrapper.EMPTY => Rez.Strings.FIELD_TYPE_EMPTY,
      DataWrapper.CALORIES_TOTAL => Rez.Strings.FIELD_TYPE_CALORIES_TOTAL,
      DataWrapper.DISTANCE => Rez.Strings.FIELD_TYPE_DISTANCE,
      DataWrapper.MOON => Rez.Strings.FIELD_TYPE_MOON,
      DataWrapper.TEMPERATURE => Rez.Strings.FIELD_TYPE_TEMPERATURE,
      DataWrapper.PRESSURE => Rez.Strings.FIELD_TYPE_PRESSURE,
      DataWrapper.RELATIVE_HUMIDITY => Rez.Strings.FIELD_TYPE_RELATIVE_HUMIDITY,
      DataWrapper.PRECIPITATION_CHANCE => Rez.Strings
        .FIELD_TYPE_PRECIPITATION_CHANCE,
      DataWrapper.TIME_ZONE => Rez.Strings.FIELD_TYPE_TIME1,
      DataWrapper.WEIGHT => Rez.Strings.FIELD_TYPE_WEIGHT,
      DataWrapper.FEELS_LIKE_TEMPERATURE => Rez.Strings
        .FIELD_TYPE_FEELS_LIKE_TEMPERATURE,
    };

    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.HR,
      Complications.COMPLICATION_TYPE_HEART_RATE
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.CALORIES_ACTIVE,
      Complications.COMPLICATION_TYPE_CALORIES
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.STEPS,
      Complications.COMPLICATION_TYPE_STEPS
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.BATTERY,
      Complications.COMPLICATION_TYPE_BATTERY
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.BODY_BATTERY,
      Complications.COMPLICATION_TYPE_BODY_BATTERY
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.RECOVERY_TIME,
      Complications.COMPLICATION_TYPE_RECOVERY_TIME
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.FLOOR,
      Complications.COMPLICATION_TYPE_FLOORS_CLIMBED
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.O2,
      Complications.COMPLICATION_TYPE_PULSE_OX
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.ALTITUDE,
      Complications.COMPLICATION_TYPE_ALTITUDE
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.STRESS,
      Complications.COMPLICATION_TYPE_STRESS
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.WEEKLY_RUN_DISTANCE,
      Complications.COMPLICATION_TYPE_WEEKLY_RUN_DISTANCE
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.WEEKLY_BIKE_DISTANCE,
      Complications.COMPLICATION_TYPE_WEEKLY_BIKE_DISTANCE
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.VO2_RUN,
      Complications.COMPLICATION_TYPE_VO2MAX_RUN
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.VO2_BIKE,
      Complications.COMPLICATION_TYPE_VO2MAX_BIKE
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.RESPIRATION_RATE,
      Complications.COMPLICATION_TYPE_RESPIRATION_RATE
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.SOLAR_INPUT,
      Complications.COMPLICATION_TYPE_SOLAR_INPUT
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.INTENSITY_MINUTES,
      Complications.COMPLICATION_TYPE_INTENSITY_MINUTES
    );
    addNewDataTypeToMenuSettings(
      pattern,
      DataWrapper.CALENDAR_EVENTS,
      Complications.COMPLICATION_TYPE_CALENDAR_EVENTS
    );
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
      :method_symbol => :savePreset,
    });

    var presets = Application.Storage.getValue(Global.PRESETS_KEY);
    if (presets != null) {
      var keys = presets.keys();
      for (var i = 0; i < keys.size(); i++) {
        items_props.add({
          :item_class => :CommandItem,
          :rez_label => Presets.presetIdToString(keys[i], presets),
          :identifier => keys[i],
          :method_symbol => :onSelectPreset,
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

    var title = Presets.presetIdToString(
      options[:id],
      Application.Storage.getValue(Global.PRESETS_KEY)
    );
    items_props.add({
      :item_class => :CommandItem,
      :rez_label => Rez.Strings.ApplyPreset,
      :sublabel => title,
      :identifier => :applyPreset,
      :method_symbol => :applyPreset,
      :method_options => options,
    });
    items_props.add({
      :item_class => :CommandItem,
      :rez_label => Rez.Strings.RemovePreset,
      :sublabel => title,
      :identifier => :removePreset,
      :method_symbol => :removePreset,
      :method_options => options,
    });
    items_props.add({
      :item_class => :PickerItem,
      :rez_label => Rez.Strings.RenamePreset,
      :sublabel => title,
      :identifier => :renamePreset,
      :method_symbol => :renamePreset,
      :method_options => options,
    });

    var sub_menu_options = {
      :title => title,
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
      :identifier => "c_image",
      :method_symbol => :createColorSelectMenu,
    });
    items_props.add({
      :item_class => :ColorPropertyItem,
      :rez_label => Rez.Strings.c_font,
      :identifier => "c_font",
      :method_symbol => :createColorSelectMenu,
    });
    items_props.add({
      :item_class => :ColorPropertyItem,
      :rez_label => Rez.Strings.c_es,
      :identifier => "c_es",
      :method_symbol => :createColorSelectMenu,
    });
    items_props.add({
      :item_class => :ColorPropertyItem,
      :rez_label => Rez.Strings.c_bgnd,
      :identifier => "c_bgnd",
      :method_symbol => :createColorSelectMenu,
    });
    items_props.add({
      :item_class => :ColorPropertyItem,
      :rez_label => Rez.Strings.c_patt,
      :identifier => "c_patt",
      :method_symbol => :createColorSelectMenu,
    });
    items_props.add({
      :item_class => :ColorPropertyItem,
      :rez_label => Rez.Strings.c_patt_d,
      :identifier => "c_patt_d",
      :method_symbol => :createColorSelectMenu,
    });
    items_props.add({
      :item_class => :ColorPropertyItem,
      :rez_label => Rez.Strings.c_scale,
      :identifier => "c_scale",
      :method_symbol => :createColorSelectMenu,
    });

    var options = {
      :title => Rez.Strings.SubmenuColors,
      :items => items_props,
    };
    return new SubMenu(options);
  }

  function getSublabel(method_symbol, value) {
    var method = new Lang.Method(Menu, method_symbol);
    var pattern = method.invoke();
    return pattern[value];
  }

  function addNewDataTypeToMenuSettings(dict, data_type, compl_type) {
    var compl_label = getNativeComplicationLabel(compl_type);
    if (compl_label instanceof Lang.String) {
      dict[data_type] = compl_label;
    }
  }

  function getNativeComplicationLabel(compl_type) {
    var res = null;
    var compl_id = new Complications.Id(compl_type);
    if (compl_id instanceof Complications.Id) {
      var compl = null;
      try {
        compl = Complications.getComplication(compl_id);
      } catch (ex) {}
      if (compl != null) {
        res = compl.longLabel;
        if (res == null) {
          res = compl.shortLabel;
        }
      }
    }
    return res;
  }

  function renamePreset(options) {
    Presets.renamePreset(options);
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
  }

  function savePreset(options) {
    Presets.savePreset(options);
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
  }

  function applyPreset(options) {
    Presets.applyPreset(options);
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
  }

  function removePreset(options) {
    Presets.removePreset(options);
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
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
