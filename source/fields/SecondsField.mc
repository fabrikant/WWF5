import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Time;

class SecondsField extends AbstractField {
  var font;
  var symb_w;

  function initialize(options) {
    AbstractField.initialize(options);
    font = options[:font];
    symb_w = null;
  }

  function draw(colors) {
    AbstractField.draw(colors);
    var dc = getDc();
    if (getApp().watch_view.isAmoledSaveMode) {
      //do nothing
    } else {
      drawValue(dc, colors);
    }

    drawBorder(dc);
  }

  function drawPartial(global_dc, colors) {
    var dc = getDc();
    if (symb_w == null) {
      symb_w = dc.getTextWidthInPixels("0", font);
    }
    if (System.getClockTime().sec % 10 == 0) {
      global_dc.setClip(getX(), getY(), dc.getWidth(), dc.getHeight());
      drawValue(dc, colors);
    } else {
      global_dc.setClip(
        getX() + symb_w,
        getY(),
        dc.getWidth() - symb_w,
        dc.getHeight()
      );
      var value = seconds();
      value = value.substring(1, 2);
      var y = dc.getHeight() / 2;
      drawText(
        dc,
        colors,
        symb_w,
        y,
        font,
        value,
        Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
      );
    }
  }

  function drawValue(dc, colors) {
    var value = seconds();
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
  }
}
