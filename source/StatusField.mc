import Toybox.Graphics;
import Toybox.System;

class StatusField extends AbstractField {
  var label_x, label_y, label_radius, label_angle, font_label;

  function initialize(options) {
    AbstractField.initialize(options);
  }

  function draw(colors) {
    AbstractField.draw(colors);
    var dc = getDc();
    dc.setColor(colors[:font], colors[:background]);

    var notifications = System.getDeviceSettings().notificationCount;
    var top = 0;
    if (notifications > 0) {
      var bitmap = createImage(Rez.Drawables.message, colors);
      dc.drawBitmap((dc.getWidth() - bitmap.getWidth()) / 2, 0, bitmap);

      top += bitmap.getDc().getHeight();

      var fontSmall = Graphics.FONT_XTINY;
      dc.drawText(
        dc.getWidth() / 2,
        top,
        fontSmall,
        notifications,
        Graphics.TEXT_JUSTIFY_CENTER
      );
      top += dc.getFontHeight(fontSmall);
    }
    drawBorder(dc);
  }
}