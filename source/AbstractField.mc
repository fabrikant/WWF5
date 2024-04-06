import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Time;

class AbstractField extends WatchUi.Layer {
  function initialize(options) {
    Layer.initialize(options);
  }

  function draw(colors) {
    var dc = getDc();
    dc.setColor(colors[:font], colors[:background]);
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

  function date() {
    var now = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
    return Lang.format("$1$, $2$ $3$", [now.day_of_week, now.day, now.month]);
  }

  function labelCastToString(label) {
    if (label instanceof Lang.String) {
      return label;
    } else if (label != null) {
      return Application.loadResource(label);
    }
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

  function drawText(dc, colors, x, y, font, text, justification) {
    var color = colors[:font];

    var color_empty = colors[:font_empty_segments];
    if (color_empty != color && color_empty != Graphics.COLOR_TRANSPARENT) {
      var chars = text.toCharArray();
      var epty_text = "";
      for (var i = 0; i < chars.size(); i++) {
        if (
          chars[i] == '0' ||
          chars[i] == '1' ||
          chars[i] == '2' ||
          chars[i] == '3' ||
          chars[i] == '4' ||
          chars[i] == '5' ||
          chars[i] == '6' ||
          chars[i] == '7' ||
          chars[i] == '9'
        ) {
          epty_text += "8";
        } else {
          epty_text += text.substring(i, i + 1);
        }
      }
      dc.setColor(color_empty, colors[:background]);
      dc.drawText(x, y, font, epty_text, justification);
    }
    dc.setColor(color, Graphics.COLOR_TRANSPARENT);

    dc.drawText(x, y, font, text, justification);
  }
}
