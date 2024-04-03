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
    AbstractField.draw(colors);
    var dc = getDc();
    dc.setColor(colors[:font], colors[:background]);
    var data = DataWrapper.getData(Application.Properties.getValue(getId()));

    var temp_x = 0;
    var bitmap_h = null;
    //если значение для вывода больше 3 знаков, картинку не рисуем - не поместится
    if (data[:value] != null) {
      if (data[:value].length() > 3) {
        data[:image] = null;
      }
    }

    if (data[:image] != null) {
      //Картинка
      if (bitmap == null){
        bitmap = createImage(data[:image], colors);
      }
      bitmap_h = bitmap.getHeight();
      dc.drawBitmap(0, dc.getHeight() - bitmap_h, bitmap);
      temp_x += bitmap.getWidth();
    }

    if (data[:value] != null) {
      var font_value = getApp().watch_view.fonts[:sun_events];
      var font_height = font_value.getHeight();
      var temp_y = dc.getHeight() - font_height;
      if (bitmap_h == null) {
        font_value.writeString(
          dc,
          temp_x,
          temp_y,
          data[:value],
          Graphics.TEXT_JUSTIFY_LEFT
        );
      } else {
        temp_y = dc.getHeight() - bitmap_h / 2;
        font_value.writeString(
          dc,
          temp_x,
          temp_y,
          data[:value],
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
      }
    }

    drawBorder(dc);
  }
}
