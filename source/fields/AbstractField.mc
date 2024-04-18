import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Time;

class AbstractField extends WatchUi.Layer {
  var compl_id;

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
    return ["RobotoCondensedRegular", "RobotoRegular"];
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

  function labelCastToString(label) {
    if (label instanceof Lang.String) {
      return label;
    } else if (label != null) {
      return Application.loadResource(label);
    }
  }

  function createImage(resource, colors) {
    if (resource instanceof Graphics.BufferedBitmapReference) {
      return resource;
    }

    var _bitmap = Application.loadResource(resource);
    var _bufferedBitmapRef = Graphics.createBufferedBitmap({
      :bitmapResource => _bitmap,
      :width => _bitmap.getWidth(),
      :height => _bitmap.getHeight(),
    });
    var _bufferedBitmap = _bufferedBitmapRef.get();
    _bufferedBitmap.setPalette([colors[:image], Graphics.COLOR_TRANSPARENT]);
    return _bufferedBitmapRef;
  }

  function checkOnPress(clickEvent) {
    var coords = clickEvent.getCoordinates();
    if (
      coords[0] >= getX() &&
      coords[0] < getX() + getDc().getWidth() &&
      coords[1] >= getY() &&
      coords[1] < getY() + getDc().getHeight()
    ) {
      return true;
    } else {
      return false;
    }
  }

  function drawText(dc, colors, x, y, font, text, justification) {
    //В шрифте нет символа °. Поэтому куча извращений, чтобы превратить % в °
    var degrees_positions = [];
    var color = colors[:font];
    var color_empty = colors[:font_empty_segments];
    var epty_text = "";
    if (
      color_empty != color &&
      color_empty != Graphics.COLOR_TRANSPARENT &&
      color_empty != colors[:background]
    ) {
      var chars = text.toCharArray();
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
        } else if (chars[i] == '°') {
          epty_text += "%";
          degrees_positions.add(i);
        } else {
          epty_text += text.substring(i, i + 1);
        }
      }
    }
    if (degrees_positions.size() == 0) {
      if (epty_text.length() > 0) {
        dc.setColor(color_empty, colors[:background]);
        dc.drawText(x, y, font, epty_text, justification);
      }

      dc.setColor(color, Graphics.COLOR_TRANSPARENT);
      dc.drawText(x, y, font, text, justification);
    } else {
      //Опеределяем точки начала символов % отностиельно остальной строки
      var x_positions = [];
      for (var i = 0; i < degrees_positions.size(); i++) {
        var pos = degrees_positions[i];
        var left_str = text.substring(null, pos);
        text = left_str + "%" + text.substring(pos + 1, null);
        x_positions.add(dc.getTextWidthInPixels(left_str, font));
      }

      //Стандартным выравниванием пользоваться не получится, так
      //как нельзя будет определить размер сдвига
      var symb_w = dc.getTextWidthInPixels("%", font);
      var x_offset = 0;
      var y_offset = 0;
      var text_w_h = dc.getTextDimensions(text, font);
      if ((justification & 4) == Graphics.TEXT_JUSTIFY_VCENTER) {
        y_offset = -text_w_h[1] / 2;
        justification -= Graphics.TEXT_JUSTIFY_VCENTER;
      }
      if (justification == Graphics.TEXT_JUSTIFY_RIGHT) {
        x_offset = -text_w_h[0];
      } else if (justification == Graphics.TEXT_JUSTIFY_CENTER) {
        x_offset = -text_w_h[0] / 2;
      }
      x_offset += (degrees_positions.size() * symb_w) / 2;

      //Пишем пустые сегменты
      if (epty_text.length() > 0) {
        System.println(epty_text);
        dc.setColor(color_empty, colors[:background]);
        dc.drawText(x + x_offset, y + y_offset, font, epty_text, Graphics.TEXT_JUSTIFY_LEFT);
      }

      //Пишем текст
      dc.setColor(color, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        x + x_offset,
        y + y_offset,
        font,
        text,
        Graphics.TEXT_JUSTIFY_LEFT
      );

      //Превращаем % в °
      //закрашиваем часть символа
      dc.setColor(colors[:background], Graphics.COLOR_TRANSPARENT);

      var k = 0.55;
      for (var i = 0; i < x_positions.size(); i++) {
        var poligon = [
          [x + x_offset + x_positions[i], y + y_offset + text_w_h[1] * k],
          [
            x + x_offset + x_positions[i] + symb_w * k,
            y + y_offset + text_w_h[1] * k,
          ],
          [x + x_offset + x_positions[i] + symb_w * k, y + y_offset],
          [x + x_offset + x_positions[i] + symb_w, y + y_offset],
          [x + x_offset + x_positions[i] + symb_w, y + y_offset + text_w_h[1]],
          [x + x_offset + x_positions[i], y + y_offset + text_w_h[1]],
        ];
        dc.fillPolygon(poligon);
      }
    }
  }
}
