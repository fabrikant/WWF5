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
    var y = dc.getHeight() / 2;
    drawText(
      dc,
      colors,
      0,
      y,
      font,
      value,
      Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
    );

    drawBorder(dc);
  }
}
