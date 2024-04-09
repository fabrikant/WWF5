import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Time;

class SimpleField extends AbstractField {
  var font;

  function initialize(options) {
    AbstractField.initialize(options);
    font = options[:font];
  }

  function draw(colors) {
    AbstractField.draw(colors);
    var dc = getDc();
    var value = self.method(getId()).invoke();
    var x = dc.getWidth() / 2;
    var y = dc.getHeight() / 2;
    var font_h = Graphics.getFontHeight(font);
    if (font_h * 4 > System.getDeviceSettings().screenHeight) {
      y -= Math.round(font_h / 32);
    }
    drawText(
      dc,
      colors,
      x,
      y,
      font,
      value,
      Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
    );

    drawBorder(dc);
  }
}
