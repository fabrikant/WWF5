import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Complications;
import Toybox.Time;
import Toybox.Math;

class SunEventsField extends SimpleField {
  var font;

  function initialize(options) {
    SimpleField.initialize(options);
    initializeFont(options);
  }

  function initializeFont(options) {
    if (options.hasKey(:font)) {
      font = options[:font];
    } else {
      var font_w = Math.floor(options[:width] / options[:max_lenght]);
      var line_w = 2;

      font = new FontLessFont({
        :width => font_w,
        :height => options[:height],
        :line_width => line_w,
        :line_offset => 2,
        :simple_style => true,
        :other_symbols => ["k", "°", ".", ":"],
      });
    }
    getApp().watch_view.fonts[options[:identifier]] = font;
  }

  function draw(colors) {
    var dc = getDc();
    dc.setColor(colors[:background], colors[:background]);
    dc.clear();
    dc.setAntiAlias(true);

    var sunrise = getSunEventTime(Complications.COMPLICATION_TYPE_SUNRISE);
    var sunset = getSunEventTime(Complications.COMPLICATION_TYPE_SUNSET);
    var image = createImage(Rez.Drawables.sunEvent, colors);
    var image_x = Math.floor((dc.getWidth() - image.getWidth()) / 2);

    dc.drawBitmap(image_x, 0 - Math.round(dc.getHeight() / 5), image);

    font.writeString(
      dc,
      image_x - 1,
      dc.getHeight() / 2,
      sunrise,
      Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
    );

    font.writeString(
      dc,
      image_x + image.getWidth() + 1,
      dc.getHeight() / 2,
      sunset,
      Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
    );

    drawBorder(dc);
  }

  function getSunEventTime(compl_id) {
    var res = "";
    var compl = Complications.getComplication(new Id(compl_id));
    if (compl.value != null) {
      var moment = Time.today().add(new Time.Duration(compl.value));
      res = hours_minutes(Time.Gregorian.info(moment, Time.FORMAT_SHORT));
    }
    return res;
  }
}
