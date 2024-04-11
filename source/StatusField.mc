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
    if (notifications > 0) {
      var bitmap = createImage(Rez.Drawables.message, colors);
      dc.drawBitmap((dc.getWidth() - bitmap.getWidth()) / 2, top, bitmap);
      top += bitmap.getHeight();
    }

    var show_connestion = Application.Properties.getValue("show_connection");
    var connected = dev_set.connectionAvailable;
    if (
      (show_connestion == Global.BLUETOOTH_SHOW_IF_CONNECT && connected) ||
      (show_connestion == Global.BLUETOOTH_SHOW_IF_DISCONNECT && !connected)
    ) {
      var bitmap = createImage(Rez.Drawables.Bluetooth, colors);
      dc.drawBitmap((dc.getWidth() - bitmap.getWidth()) / 2, top, bitmap);
      top += bitmap.getHeight();
    }

    if (dev_set.doNotDisturb) {
      if (Application.Properties.getValue("show_DND")) {
        var bitmap = createImage(Rez.Drawables.DND, colors);
        dc.drawBitmap((dc.getWidth() - bitmap.getWidth()) / 2, top, bitmap);
        top += bitmap.getHeight();
      }
    }

    drawBorder(dc);
  }
}
