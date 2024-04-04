import Toybox.Graphics;
import Toybox.System;
import Toybox.Math;
import Toybox.Complications;
import Toybox.Lang;

class SmallField extends AbstractField {
  var bitmap;

  function initialize(options) {
    AbstractField.initialize(options);
    bitmap = null;
  }

  function draw(colors) {
    var dc = getDc();
    AbstractField.draw(colors);

    var data = DataWrapper.getData(Application.Properties.getValue(getId()));

    var temp_x = 0;
    var bitmap_h = null;

    var data_value = data[:value];
    if (data_value != null) {
      if (getApp().watch_view.isPartialUpdate || data_value.length() > 3) {
        data[:image] = null;
      }
    }

    if (data[:image] != null) {
      //Картинка
      if (bitmap == null) {
        bitmap = createImage(data[:image], colors);
      }
      bitmap_h = bitmap.getHeight();
      dc.drawBitmap(0, (dc.getHeight() - bitmap_h) / 2, bitmap);
      temp_x += bitmap.getWidth();
    }

    if (data_value != null) {
      var font_value = getApp().watch_view.fontValues;
      drawText(
        dc,
        colors,
        temp_x,
        dc.getHeight() / 2,
        font_value,
        data_value,
        Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
      );

      // var font_height = Graphics.getFontHeight(font_value);
      // var temp_y = dc.getHeight() - font_height;
      // if (bitmap_h == null) {
      //   drawText(
      //     dc,
      //     colors,
      //     temp_x,
      //     temp_y,
      //     font_value,
      //     data_value,
      //     Graphics.TEXT_JUSTIFY_LEFT
      //   );
      // } else {
      //   temp_y = dc.getHeight() - bitmap_h / 2;
      //   drawText(
      //     dc,
      //     colors,
      //     temp_x,
      //     temp_y,
      //     font_value,
      //     data_value,
      //     Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
      //   );
      // }
    }

    drawBorder(dc);
  }
}
