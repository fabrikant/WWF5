import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Complications;
import Toybox.Time;
import Toybox.Math;

class SunEventsField extends AbstractField {
  var fontComplication = null;

  function initialize(options) {
    AbstractField.initialize(options);
    compl_id = new Complications.Id(Complications.COMPLICATION_TYPE_SUNRISE);
  }

  function draw(colors) {
    var fieldType = Application.Properties.getValue(getId());
    AbstractField.draw(colors);

    if (fieldType == DataWrapper.SUN_EVENTS) {
      drawSunEvents(colors);
    } else if (fieldType == DataWrapper.THIRD_PARTY_COMPLICATION) {
      drawComplication(colors);
    }
  }

  function drawComplication(colors) {
    var complId = Application.Storage.getValue(getId());
    if (complId != null) {
      var compl = Complications.getComplication(complId);
      if (compl instanceof Complications.Complication) {
        if (compl.value != null) {
          var text = compl.value;
          if (compl.unit instanceof Lang.String) {
            text += " " + compl.unit;
          }

          var dc = getDc();
          dc.setColor(colors[:font], colors[:background]);

          if (fontComplication == null) {
            fontComplication = Graphics.getVectorFont({
              :face => vectorFontName(),
              :size => (dc.getHeight() * 1.2).toNumber(),
            });
          }

          dc.drawText(0, 0, fontComplication, text, Graphics.TEXT_JUSTIFY_LEFT);
          return;
        }
      }
    }

    drawSunEvents(colors);
  }

  function drawSunEvents(colors) {
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
    var compl = null;
    try {
      compl = Complications.getComplication(new Complications.Id(compl_id));
    } catch (ex) {
      return res;
    }
    if (compl.value != null) {
      var moment = Time.today().add(new Time.Duration(compl.value));
      res = hours_minutes(Time.Gregorian.info(moment, Time.FORMAT_SHORT));
    }
    return res;
  }
}
