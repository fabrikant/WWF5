import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;

class BottomField extends AbstractField {
  var font;
  var small_bitmap;

  function initialize(options) {
    small_bitmap = null;
    initializeFont(options);
    AbstractField.initialize(options);
  }

  function initializeFont(options) {
    font = Graphics.getVectorFont({
      :face => vectorFontName(),
      :size => Math.floor(options[:height] * 1.2),
    });
  }

  function draw(colors) {
    AbstractField.draw(colors);
    var dc = getDc();
    dc.setColor(colors[:font], colors[:background]);
    var data = DataWrapper.getData(Application.Properties.getValue(getId()));
    compl_id = data[:compl_id];

    if (data[:value] != null) {
      if (data[:value].length() < 7 && data[:image] != null) {
        var bitmap_w = 0;
        var offset = 5;
        var text_w = dc.getTextWidthInPixels(data[:value], font);
        var temp_x = (dc.getWidth() - text_w - offset) / 2;

        if (small_bitmap == null) {
          var bitmap = createImage(data[:image], colors);
          small_bitmap = Graphics.createBufferedBitmap({
            :width => bitmap.getWidth(),
            :height => bitmap.getHeight(),
          });
          small_bitmap.get().getDc().drawBitmap(0, 0, bitmap);
        }

        if (small_bitmap != null) {
          var reduction_factor = 0.7;
          bitmap_w = small_bitmap.getWidth() * reduction_factor;
          temp_x = (dc.getWidth() - bitmap_w - text_w - offset) / 2;

          var transform = new Graphics.AffineTransform();
          transform.scale(reduction_factor, reduction_factor);
          dc.drawBitmap2(temp_x, 0, small_bitmap, {
            :transform => transform,
          });
        }
        temp_x += bitmap_w + offset;
        dc.drawText(temp_x, -2, font, data[:value], Graphics.TEXT_JUSTIFY_LEFT);
      } else {
        dc.drawText(
          dc.getWidth() / 2,
          -2,
          font,
          data[:value],
          Graphics.TEXT_JUSTIFY_CENTER
        );
      }
    }

    drawBorder(dc);
  }
}
