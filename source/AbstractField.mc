import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Time;
import Toybox.Complications;

class AbstractField extends WatchUi.Layer {
  function initialize(options) {
    Layer.initialize(options);
  }

  function draw(colors) {
    var dc = getDc();
    dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
    dc.clear();
    dc.setAntiAlias(true);
  }

  function drawBorder(dc) {
    return;
    dc.setPenWidth(1);
    dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_GREEN);
    dc.drawRectangle(0, 0, dc.getWidth(), dc.getHeight());
  }

  function scaleWidth() {
    return Math.round(
      System.getDeviceSettings().screenHeight * 0.04
    ).toNumber();
  }

  function vectorFontName() {
    return "RobotoCondensedRegular";
  }

  function getComplicationValueString(compl) {
    var value = compl.value;
    var res = "";

    if (compl.unit == Complications.UNIT_DISTANCE) {
      res = distanceToString(value);
    } else if (
      compl.unit == Complications.UNIT_ELEVATION ||
      compl.unit == Complications.UNIT_HEIGHT
    ) {
      res = elevationToString(value);
    } else if (compl.unit == Complications.UNIT_SPEED) {
      res = speedToString(value);
    } else if (compl.unit == Complications.UNIT_TEMPERATURE) {
      res = convertValueTemperature(value);
    } else if (compl.unit == Complications.UNIT_WEIGHT) {
      res = weightToString(value);
    } else {
      if (compl.unit instanceof Lang.String) {
        if (compl.unit.equals("K")) {
          var fString = "%.2f";
          if (value >= 10) {
            fString = "%.1f";
          }
          if (value >= 100) {
            fString = "%d";
          }
          res = value.format(fString) + "k";
        }
      } else {
        res = reduceLongValue(value);
      }
    }
    return res;
  }

  //******************************************************
  //convertation values

  function weightToString(value) {
    if (System.getDeviceSettings().weightUnits == System.UNIT_STATUTE) {
      /*foot*/
      value *= 0.00220462;
    } else {
      value /= 1000;
    }
    return reduceLongValue(value);
  }

  function speedToString(value) {
    if (System.getDeviceSettings().paceUnits == System.UNIT_STATUTE) {
      /*foot*/
      value *= 3.281;
    }
    return reduceLongValue(value);
  }

  function elevationToString(value) {
    if (System.getDeviceSettings().elevationUnits == System.UNIT_STATUTE) {
      /*foot*/
      value *= 3.281;
    }

    return reduceLongValue(value);
  }

  function distanceToString(value) {
    if (System.getDeviceSettings().distanceUnits == System.UNIT_METRIC) {
      /*km*/
      value = value / 100000.0;
    } else {
      /*mile*/
      value = value / 160934.4;
    }
    var fString = "%.2f";
    if (value >= 10) {
      fString = "%.1f";
    }
    if (value >= 100) {
      fString = "%d";
    }
    value.format(fString);
  }

  function clock() {
    return hours_minutes(System.getClockTime());
  }

  function hours_minutes(clock) {
    var hours = clock.hour;
    if (!System.getDeviceSettings().is24Hour) {
      if (hours > 12) {
        hours = hours - 12;
      }
    }
    return Lang.format("$1$:$2$", [
      hours.format("%02d"),
      clock.min.format("%02d"),
    ]);
  }

  function hours() {
    var hours = System.getClockTime().hour;
    if (!System.getDeviceSettings().is24Hour) {
      if (hours > 12) {
        hours = hours - 12;
      }
    }
    return hours.format("%02d");
  }

  function minutes() {
    return System.getClockTime().min.format("%02d");
  }

  function seconds() {
    return System.getClockTime().sec.format("%02d");
  }

  function date() {
    var now = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
    return Lang.format("$1$, $2$ $3$", [now.day_of_week, now.day, now.month]);
  }

  function createImage(resource, colors) {
    var _bitmap = Application.loadResource(resource);
    if (Graphics has :createBufferedBitmap) {
      var _bufferedBitmapRef = Graphics.createBufferedBitmap({
        :bitmapResource => _bitmap,
        :width => _bitmap.getWidth(),
        :height => _bitmap.getHeight(),
      });
      var _bufferedBitmap = _bufferedBitmapRef.get();
      _bufferedBitmap.setPalette([colors[:font], Graphics.COLOR_TRANSPARENT]);
      return _bufferedBitmap;
    } else {
      var _bufferedBitmap = new Graphics.BufferedBitmap({
        :bitmapResource => _bitmap,
        :width => _bitmap.getWidth(),
        :height => _bitmap.getHeight(),
      });
      _bufferedBitmap.setPalette([colors[:font], Graphics.COLOR_TRANSPARENT]);
      return _bufferedBitmap;
    }
  }

  function convertValueTemperature(сelsius) {
    var value;
    if (сelsius != null) {
      if (System.getDeviceSettings().temperatureUnits == System.UNIT_STATUTE) {
        /*F*/
        value = (сelsius * 9) / 5 + 32;
      } else {
        value = сelsius;
      }
    } else {
      value = "";
    }
    return value.format("%d") + "°";
  }

  function reduceLongValue(value) {
    if (value > 9999) {
      value = (value / 1000).format("%.1f") + "k";
    } else {
      value = value.toString();
      if (value.substring(3, 4).equals(".")) {
        value = value.substring(0, 3);
      } else {
        value = value.substring(0, 4);
      }
      //value = value.format("%d");
    }
    return value;
  }

  function converValueWindSpeed(wind_speed) {
    var value = wind_speed; //meters/sec
    var unit_str = "";
    var unit = Application.Properties.getValue("wind_speed_unit");
    if (unit == Global.UNIT_SPEED_MS) {
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitMSec);
    } else if (unit == Global.UNIT_SPEED_KMH) {
      /*km/h*/
      value = wind_speed * 3.6;
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitKmH);
    } else if (unit == Global.UNIT_SPEED_MLH) {
      /*mile/h*/
      value = wind_speed * 2.237;
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitMileH);
    } else if (unit == Global.UNIT_SPEED_FTS) {
      /*ft/s*/
      value = wind_speed * 3.281;
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitFtSec);
    } else if (unit == Global.UNIT_SPEED_BEAUF) {
      /*Beaufort*/
      value = getBeaufort(wind_speed);
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitBeauf);
    } else if (unit == Global.UNIT_SPEED_KNOTS) {
      /*knots*/
      value = wind_speed * 1.94384;
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitKnots);
    }
    return value.format("%d") + " " + unit_str;
  }

  function getBeaufort(wind_speed) {
    if (wind_speed >= 33) {
      return 12;
    } else if (wind_speed >= 28.5) {
      return 11;
    } else if (wind_speed >= 24.5) {
      return 10;
    } else if (wind_speed >= 20.8) {
      return 9;
    } else if (wind_speed >= 17.2) {
      return 8;
    } else if (wind_speed >= 13.9) {
      return 7;
    } else if (wind_speed >= 10.8) {
      return 6;
    } else if (wind_speed >= 8) {
      return 5;
    } else if (wind_speed >= 5.5) {
      return 4;
    } else if (wind_speed >= 3.4) {
      return 3;
    } else if (wind_speed >= 1.6) {
      return 2;
    } else if (wind_speed >= 0.3) {
      return 1;
    } else {
      return 0;
    }
  }
}
