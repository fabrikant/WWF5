import Toybox.Complications;

(:background)
module Global {
  enum {
    UNIT_SPEED_MS = 0,
    UNIT_SPEED_KMH,
    UNIT_SPEED_MLH,
    UNIT_SPEED_FTS,
    UNIT_SPEED_BEAUF,
    UNIT_SPEED_KNOTS,

    BLUETOOTH_SHOW_IF_CONNECT = 0,
    BLUETOOTH_SHOW_IF_DISCONNECT,
    BLUETOOTH_HIDE,

    PRESETS_KEY = 0,
    PRESETS_NAME_KEY,
    LOCATION_KEY,
    CURRENT_WEATHER_KEY,
    STORAGE_KEY_RESPONCE_CODE,
    STORAGE_KEY_UPDATE_MOMENT,
    STORAGE_KEY_TEMP,
    STORAGE_KEY_ICON,
    STORAGE_KEY_WEATHER_ID,
    STORAGE_KEY_WIND_SPEED,
    STORAGE_KEY_WIND_DEG,
    STORAGE_KEY_WEATHER_MAIN,
    STORAGE_KEY_WEATHER_CITY,
  }

  function getPropertiesKeys() {
    return [
      "c_patt",
      "c_patt_d",
      "c_bgnd",
      "c_font",
      "c_es",
      "c_image",
      "c_scale",
      "wind_speed_unit",
      "pressure_unit",
      "data_scale",
      "data_small",
      "data_1",
      "data_2",
      "data_3",
      "data_bottom",
      "show_connection",
      "show_DND",
      "T1TZ",
    ];
  }

  function min(a, b) {
    if (a < b) {
      return a;
    } else {
      return b;
    }
  }

  function max(a, b) {
    if (a < b) {
      return b;
    } else {
      return a;
    }
  }

  function mod(a) {
    if (a > 0) {
      return a;
    } else {
      return -a;
    }
  }
}
