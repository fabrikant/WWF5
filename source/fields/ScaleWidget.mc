import Toybox.Graphics;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Complications;
import Toybox.Lang;

class ScaleWidget extends AbstractField {
  var angle_min, angle_max, center_x, center_y;
  var clear_poligon;
  var small_bitmap;

  function initialize(options) {
    AbstractField.initialize(options);
    var system_radius = System.getDeviceSettings().screenHeight / 2;
    var pattern = getApp().watch_view.pattern;
    var offset_fegree = 5;
    var dc = getDc();
    var sin_angle =
      (system_radius - pattern.reference_points[:y][2]).toFloat() /
      system_radius;
    angle_min = 180f - Math.toDegrees(Math.asin(sin_angle)) - offset_fegree;
    sin_angle =
      (system_radius - pattern.reference_points[:y][1]).toFloat() /
      system_radius;
    angle_max = 180f - Math.toDegrees(Math.asin(sin_angle)) + offset_fegree;
    center_x =
      dc.getWidth() + Global.mod(getX() + dc.getWidth() - system_radius);
    center_y =
      dc.getHeight() + Global.mod(getY() + dc.getHeight() - system_radius);

    var ref_points = getApp().watch_view.pattern.reference_points;
    clear_poligon = [
      [0, 0],
      [0, dc.getHeight()],
      [dc.getWidth(), dc.getHeight()],
      [dc.getWidth() - Global.mod(ref_points[:x][2] - ref_points[:x][1]), 0],
    ];
    small_bitmap = null;
  }

  function draw(colors) {
    //AbstractField.draw(colors);
    var dc = getDc();
    dc.setColor(colors[:background], colors[:background]);
    dc.fillPolygon(clear_poligon);
    dc.setAntiAlias(true);

    var data = DataWrapper.getData(Application.Properties.getValue(getId()));
    compl_id = data[:compl_id];

    if (data[:scale_value] != null) {
      drawScale(dc, colors, data, scaleWidth());
    } else {
      drawData(dc, colors, data);
    }
    drawBorder(dc);
  }

  //***************************************************************************
  //Рисуем поле с данными
  function drawData(dc, colors, data) {
    var font_value = getApp().watch_view.fontValues;
    var temp_y = dc.getHeight() - Graphics.getFontHeight(font_value);
    //Значение
    if (data[:value] != null) {
      drawText(
        dc,
        colors,
        dc.getWidth() / 2,
        temp_y,
        font_value,
        data[:value],
        Graphics.TEXT_JUSTIFY_CENTER
      );
    }

    if (data[:image] != null) {
      //Картинка
      var bitmap = createImage(data[:image], colors);
      temp_y -= bitmap.getHeight() * 1.2;
      dc.drawBitmap(dc.getWidth() / 2, temp_y, bitmap);
    } else if (data[:label] != null) {
      //или текстовая метка
      dc.setColor(colors[:font], colors[:background]);
      var font_label = Graphics.getVectorFont({
        :face => vectorFontName(),
        :size => vectorFontHeight(),
      });
      temp_y -= Graphics.getFontHeight(font_label);
      var label = labelCastToString(data[:label]);
      dc.drawText(
        dc.getWidth() * 0.75,
        temp_y,
        font_label,
        label.substring(0, 4),
        Graphics.TEXT_JUSTIFY_RIGHT
      );
    }
  }

  //***************************************************************************
  //Рисуем поле со шкалой
  function drawScale(dc, colors, data, scale_width) {
    //Подпись
    var font_value = getApp().watch_view.fontValues;
    var temp_y = dc.getHeight() - Graphics.getFontHeight(font_value);
    var temp_x = scale_width + dc.getWidth() / 2;
    if (data[:value] != null) {
      drawText(
        dc,
        colors,
        temp_x,
        temp_y,
        font_value,
        data[:value],
        Graphics.TEXT_JUSTIFY_CENTER
      );
    }

    //Значок нужно уменьшить
    if (data[:image] != null) {
      if (small_bitmap == null) {
        var bitmap = createImage(data[:image], colors);
        small_bitmap = Graphics.createBufferedBitmap({
          :width => bitmap.getWidth(),
          :height => bitmap.getHeight(),
        });
        small_bitmap.get().getDc().drawBitmap(0, 0, bitmap);
      }

      var reduction_factor = 0.7;
      temp_y -= small_bitmap.getHeight() * reduction_factor;
      var transform = new Graphics.AffineTransform();
      transform.scale(reduction_factor, reduction_factor);
      dc.drawBitmap2(temp_x, temp_y, small_bitmap, {
        :transform => transform,
      });
    }

    //Шкала
    var system_radius = System.getDeviceSettings().screenHeight / 2;
    var scale_radius = system_radius - scale_width / 2;

    dc.setPenWidth(scale_width);
    dc.setColor(colors[:font], colors[:font]);

    dc.drawArc(
      center_x,
      center_y,
      scale_radius,
      Graphics.ARC_CLOCKWISE,
      angle_min,
      angle_max
    );

    dc.setPenWidth(scale_width - 2);
    dc.setColor(colors[:background], colors[:background]);
    dc.drawArc(
      center_x,
      center_y,
      scale_radius,
      Graphics.ARC_CLOCKWISE,
      angle_min - 1,
      angle_max + 1
    );

    var data_scale = Global.min(data[:scale_value], 100);
    var angle_value =
      angle_min - (data_scale * Global.mod(angle_min - angle_max)) / 100;

    var scale_color = Graphics.COLOR_GREEN;
    if (data_scale <= 20) {
      scale_color = Graphics.COLOR_RED;
    }

    if (angle_min - angle_value < 1) {
      angle_value -= 1;
    }

    dc.setColor(scale_color, scale_color);
    dc.drawArc(
      center_x,
      center_y,
      scale_radius,
      Graphics.ARC_CLOCKWISE,
      angle_min,
      angle_value
    );

    // Подпись полукруглым текстом
    // if (data[:value] != null) {
    //   dc.setColor(colors[:font], colors[:background]);
    //   var font_height = vectorFontHeight();
    //   var font = Graphics.getVectorFont({
    //     :face => vectorFontName(),
    //     :size => font_height,
    //   });

    //   var str_angle = angle_min - Global.mod(angle_min - angle_max) / 2;
    //   dc.drawRadialText(
    //     center_x,
    //     center_y,
    //     font,
    //     data[:value],
    //     Graphics.TEXT_JUSTIFY_CENTER,
    //     str_angle,
    //     system_radius - scale_width - font_height,
    //     Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE
    //   );
    // }
  }

  function vectorFontHeight() {
    return Math.round(
      System.getDeviceSettings().screenHeight * 0.105
    ).toNumber();
  }
}
