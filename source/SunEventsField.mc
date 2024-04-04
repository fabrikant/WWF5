import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Complications;
import Toybox.Time;
import Toybox.Math;

class SunEventsField extends AbstractField {
  function initialize(options) {
    AbstractField.initialize(options);
  }

  function draw(colors) {
    AbstractField.draw(colors);
    var dc = getDc();

    var sunrise = getSunEventTime(Complications.COMPLICATION_TYPE_SUNRISE);
    var sunset = getSunEventTime(Complications.COMPLICATION_TYPE_SUNSET);
    var image = createImage(Rez.Drawables.sunEvent, colors);
    var image_x = Math.floor((dc.getWidth() - image.getWidth()) / 2);
    var image_y = Math.floor((dc.getHeight() - image.getHeight()) / 2);

    dc.drawBitmap(image_x, image_y, image);

    var font = getApp().watch_view.fontValues;
    drawText(
      dc,
      colors,
      image_x - 1,
      dc.getHeight() / 2,
      font,
      sunrise,
      Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
    );

    drawText(
      dc,
      colors,
      image_x + image.getWidth() + 1,
      dc.getHeight() / 2,
      font,
      sunset,
      Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
    );

    drawBorder(dc);
  }

  function getSunEventTime(compl_id) {
    var res = "";
    var compl = Complications.getComplication(new Complications.Id(compl_id));
    if (compl.value != null) {
      var moment = Time.today().add(new Time.Duration(compl.value));
      res = hours_minutes(Time.Gregorian.info(moment, Time.FORMAT_SHORT));
    }
    return res;
  }
}
