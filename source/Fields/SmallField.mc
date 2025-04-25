import Toybox.Graphics;
import Toybox.System;
import Toybox.Math;
import Toybox.Complications;
import Toybox.Lang;

class SmallField extends AbstractEverySecondField {
  var isPartiallyUpdateableField, bitmap_w, max_part_update_value_w, old_value;
  var font;
  const bitmap_offset = 4;

  function initialize(options) {
    AbstractEverySecondField.initialize(options);
    isPartiallyUpdateableField = false;
    bitmap_w = 0;
    max_part_update_value_w = null;
    old_value = null;
    font = getApp().watch_view.fontValues;
  }

  function draw(colors) {
    var dc = getDc();
    AbstractField.draw(colors);

    var data_type = Application.Properties.getValue(getId());
    if (data_type == DataWrapper.HR) {
      isPartiallyUpdateableField = true;
    }

    var data = DataWrapper.getData(data_type, false);

    compl_id = data[:compl_id];

    var temp_x = 0;
    var bitmap_h = null;

    var data_value = data[:value];
    if (data_value != null) {
      if (data_value.length() > 3) {
        data[:image] = null;
      }
    }

    if (data[:image] != null) {
      //Картинка
      var bitmap = createImage(data[:image], colors);
      bitmap_h = bitmap.getHeight();
      bitmap_w = bitmap.getWidth();
      dc.drawBitmap(0, (dc.getHeight() - bitmap_h) / 2, bitmap);
      temp_x += bitmap.getWidth() + bitmap_offset;
    }

    if (data_value != null) {
      drawText(
        dc,
        colors,
        temp_x,
        dc.getHeight() / 2,
        font,
        data_value,
        Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
      );
    }

    drawBorder(dc);
  }

  function drawPartial(global_dc, colors) {
    if (isPartiallyUpdateableField) {
      if (System.getClockTime().sec % 3 == 0){
        return;
      }

      var data = DataWrapper.getData(DataWrapper.HR, false);
      if (data[:value] == null) {
        return;
      }
      if (data[:value].equals(old_value)) {
        return;
      }
      old_value = data[:value];

      var dc = getDc();
      var x_offset = bitmap_w + bitmap_offset;

      if (max_part_update_value_w == null) {
        max_part_update_value_w = dc.getTextWidthInPixels("000", font);
      }
      global_dc.setClip(
        getX() + x_offset,
        getY(),
        max_part_update_value_w,
        dc.getHeight()
      );

      dc.setColor(colors[:background], colors[:background]);
      dc.fillRectangle(x_offset, 0, max_part_update_value_w, dc.getHeight());

      if (data[:value] != null) {
        drawText(
          dc,
          colors,
          bitmap_w + bitmap_offset,
          dc.getHeight() / 2,
          font,
          data[:value],
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
      }
    }
  }
}
