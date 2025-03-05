import Toybox.Graphics;
import Toybox.System;

class StatusField extends AbstractField {
  function initialize(options) {
    AbstractField.initialize(options);
    compl_id = new Complications.Id(
      Complications.COMPLICATION_TYPE_NOTIFICATION_COUNT
    );
  }

  function draw(colors) {
    AbstractField.draw(colors);
    var dc = getDc();
    dc.setColor(colors[:font], colors[:background]);

    var dev_set = System.getDeviceSettings();

    var notifications = dev_set.notificationCount;
    var top = 0;
    var colors_status = {};
    if (notifications > 0) {
      colors_status[:image] = colors[:image];
    } else {
      colors_status[:image] = colors[:font_empty_segments];
    }
    var bitmap = createImage(Rez.Drawables.message, colors_status);
    dc.drawBitmap((dc.getWidth() - bitmap.getWidth()) / 2, top, bitmap);
    top += bitmap.getHeight();

    var show_connestion = Application.Properties.getValue("show_connection");
    if (show_connestion != Global.BLUETOOTH_HIDE) {
      var connected = dev_set.connectionAvailable;
      if (
        (show_connestion == Global.BLUETOOTH_SHOW_IF_CONNECT && connected) ||
        (show_connestion == Global.BLUETOOTH_SHOW_IF_DISCONNECT && !connected)
      ) {
        colors_status[:image] = colors[:image];
      } else {
        colors_status[:image] = colors[:font_empty_segments];
      }
      bitmap = createImage(Rez.Drawables.Bluetooth, colors_status);
      dc.drawBitmap((dc.getWidth() - bitmap.getWidth()) / 2, top, bitmap);
      top += bitmap.getHeight();
    }

    if (Application.Properties.getValue("show_DND")) {
      colors_status[:image] = colors[:font_empty_segments];
      if (dev_set.doNotDisturb) {
        colors_status[:image] = colors[:image];
      }
      bitmap = createImage(Rez.Drawables.DND, colors_status);
      dc.drawBitmap((dc.getWidth() - bitmap.getWidth()) / 2, top, bitmap);
      top += bitmap.getHeight();
    }

    drawBorder(dc);
  }
}
