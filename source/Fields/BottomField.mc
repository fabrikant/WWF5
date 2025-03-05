import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;

class BottomField extends AbstractField {
  var font;

  function initialize(options) {
    initializeFont(options);
    AbstractField.initialize(options);
  }

  function initializeFont(options) {
    font = Graphics.getVectorFont({
      :face => vectorFontName(),
      :size => Math.floor(options[:height] * 1.3),
    });
  }

  function draw(colors) {
    AbstractField.draw(colors);
    var dc = getDc();
    dc.setColor(colors[:font], colors[:background]);
    var data_type = Application.Properties.getValue(getId());
    var data = null;
    if (data_type == DataWrapper.BATTERY) {
      data = DataWrapper.getData(data_type, false);
    } else {
      data = DataWrapper.getData(data_type, true);
    }

    compl_id = data[:compl_id];

    if (data[:value] != null) {
      if (data[:value].length() < 7 && data[:image] != null) {
        var bitmap_w = 0;
        var offset = 5;
        var text_w = dc.getTextWidthInPixels(data[:value], font);
        var temp_x = (dc.getWidth() - text_w - offset) / 2;

        if (data[:image] != null) {
          var bitmap = createImage(data[:image], colors);
          bitmap_w = bitmap.getWidth();
          temp_x = (dc.getWidth() - bitmap_w - text_w - offset) / 2;
          var temp_y = (dc.getHeight() - bitmap.getHeight()) / 2;
          dc.drawBitmap(temp_x, temp_y, bitmap);
        }

        temp_x += bitmap_w + offset;
        dc.drawText(
          temp_x,
          dc.getHeight() * 0.4,
          font,
          data[:value],
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
      } else {
        dc.drawText(
          dc.getWidth() / 2,
          dc.getHeight() * 0.4,
          font,
          data[:value],
          Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
      }
    }

    drawBorder(dc);
  }
}
