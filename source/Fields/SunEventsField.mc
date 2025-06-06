import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Complications;
import Toybox.Time;
import Toybox.Math;

class SunEventsField extends AbstractField {
  var fontComplication = null;
  var complIcon = null;
  var complIconH = null;
  var complIconW = null;
  var firstGetICon = null;
  var isSubscribed = null;

  function initialize(options) {
    firstGetICon = true;
    AbstractField.initialize(options);
    compl_id = new Complications.Id(Complications.COMPLICATION_TYPE_SUNRISE);
    isSubscribed = false;
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
      var compl = null;
      try {
        compl = Complications.getComplication(complId);
      } catch (e) {
        logger.error(e);
        drawSunEvents(colors);
        return;
      }
      if (compl instanceof Complications.Complication) {
        compl_id = complId;
        if (!isSubscribed) {
          isSubscribed = true;
          Complications.subscribeToUpdates(compl_id);
        }

        if (compl.value != null and !compl.value.equals("")) {
          var text = compl.value;
          if (compl.unit instanceof Lang.String) {
            text += " " + compl.unit;
          }

          var dc = getDc();

          if (fontComplication == null) {
            fontComplication = Graphics.getVectorFont({
              :face => vectorFontName(),
              :size => (dc.getHeight() * 1.2).toNumber(),
            });
          }

          var textW = dc.getTextWidthInPixels(text, fontComplication);

          dc.setColor(colors[:font], colors[:background]);
          getComplicationIcon(compl);

          // Будем выводить иконку только если поместится и она и текст
          var startX = dc.getHeight() / 4;
          var x = startX;
          if (complIcon != null) {
            var alldataW = 2 * startX + complIconW + textW;
            if (alldataW <= dc.getWidth()) {
              //Все помещается. Выведем в центре поля
              x = (dc.getWidth() - alldataW) / 2;
              dc.drawScaledBitmap(x, 0, complIconW, complIconH, complIcon);
              x += startX + complIconW;
            }
          }

          dc.drawText(
            x,
            dc.getHeight() / 2,
            fontComplication,
            text,
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
          );
          return;
        }
      }
    }

    drawSunEvents(colors);
  }

  function getComplicationIcon(compl) {
    if (!firstGetICon) {
      return;
    }
    firstGetICon = false;
    var dc = getDc();
    if (!(dc has :drawScaledBitmap)) {
      return;
    }
    complIcon = compl.getIcon();
    if (complIcon == null) {
      return;
    }

    var h = complIcon.getHeight();
    if (h == 0) {
      return;
    }
    var k = dc.getHeight().toDouble() / h;
    complIconH = (h * k).toNumber();
    complIconW = (complIcon.getWidth() * k).toNumber();
  }

  function drawSunEvents(colors) {
    compl_id = new Complications.Id(Complications.COMPLICATION_TYPE_SUNRISE);

    Complications.unsubscribeFromAllUpdates();
    isSubscribed = false;

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
