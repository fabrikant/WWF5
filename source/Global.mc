import Toybox.Complications;

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

    PRESETS_STORAGE_KEY = 0,
    PRESET_NAME_KEY
  }

  function getPropertiesKeys() {
    return [
      "color_pattern",
      "color_pattern_decorate",
      "color_background",
      "color_font",
      "color_font_empty_segments",
      "color_image",
      "color_scale",
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
