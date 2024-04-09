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
