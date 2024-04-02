import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class PatternField extends WatchUi.Layer {
  var pattern;

  function initialize(options) {
    self.pattern = options[:pattern];
    Layer.initialize(options);
  }

  function draw(colors) {
    var dc = getDc();
    dc.drawBitmap(0, 0, pattern.background_image);
  }
}

class Pattern {
  var reference_points;
  var background_image;

  function initialize(all_colors) {
    var opt = {
      :width => System.getDeviceSettings().screenWidth,
      :height => System.getDeviceSettings().screenHeight,
    };

    if (Graphics has :createBufferedBitmap) {
      background_image = Graphics.createBufferedBitmap(opt).get();
    } else {
      background_image = new Graphics.BufferedBitmap(opt);
    }

    reference_points = drawBackgoundPattern(all_colors);
  }

  private function drawBackgoundPattern(all_colors) {
    var dc = background_image.getDc();
    var colors = [all_colors[:pattern], all_colors[:pattern_decorate]];
    var pen_widths = [Math.floor(dc.getWidth() / 50), 1];

    var r = dc.getWidth() / 2;
    var center = [dc.getWidth() / 2 - 1, dc.getHeight() / 2 - 1];
    dc.setAntiAlias(true);

    //Верхняя дуга
    var arc_angle = 95;
    var arc_angle_offset = 20;
    for (var i = 0; i < colors.size(); i++) {
      dc.setColor(colors[i], colors[i]);
      dc.setPenWidth(pen_widths[i]);
      dc.drawArc(
        center[0],
        center[1],
        r,
        Graphics.ARC_COUNTER_CLOCKWISE,
        arc_angle_offset,
        arc_angle_offset + arc_angle
      );
    }

    //Вычисление координат относительно верхней дуги
    var x1 =
      center[0] + r * Math.cos(Math.toRadians(arc_angle_offset + arc_angle));
    var x2 = Math.floor(dc.getWidth() * 0.35);
    var y1 =
      center[1] - r * Math.sin(Math.toRadians(arc_angle_offset + arc_angle));
    var y2 = center[1] - r * Math.sin(Math.toRadians(arc_angle_offset));
    var interseption = calculateHorizontalIntersection(dc, y2);
    var x5 = interseption[0];
    var x6 = interseption[1];

    for (var i = 0; i < colors.size(); i++) {
      dc.setColor(colors[i], colors[i]);
      dc.setPenWidth(pen_widths[i]);
      //Верхняя перекладина
      dc.drawLine(x5, y2, x6, y2);
      //Верхняя косая черта
      dc.drawLine(x1, y1, x2, y2);
    }

    //Нижние дуги
    var arc_angle_bottom = 33;
    var arc_angle_offset_bottom = 37;
    for (var i = 0; i < colors.size(); i++) {
      dc.setColor(colors[i], colors[i]);
      dc.setPenWidth(pen_widths[i]);

      dc.drawArc(
        center[0],
        center[1],
        r,
        Graphics.ARC_CLOCKWISE,
        270 - arc_angle_offset_bottom,
        270 - arc_angle_offset_bottom - arc_angle_bottom
      );
      dc.drawArc(
        center[0],
        center[1],
        r,
        Graphics.ARC_COUNTER_CLOCKWISE,
        270 + arc_angle_offset_bottom,
        270 + arc_angle_offset_bottom + arc_angle_bottom
      );
    }

    var y4 =
      center[1] +
      r *
        Math.sin(
          Math.toRadians(90 - arc_angle_bottom - arc_angle_offset_bottom)
        );
    var y5 =
      center[1] + r * Math.sin(Math.toRadians(90 - arc_angle_offset_bottom));

    interseption = calculateHorizontalIntersection(dc, y4);
    var x8 = interseption[0];
    var x9 = interseption[1];

    interseption = calculateHorizontalIntersection(dc, y5);
    var x10 = interseption[0];
    var x11 = interseption[1];

    for (var i = 0; i < colors.size(); i++) {
      dc.setColor(colors[i], colors[i]);
      dc.setPenWidth(pen_widths[i]);
      //Перекладина нижних дуг верхняя
      dc.drawLine(x8, y4, x9, y4);
      //Перекладина нижних дуг нижняя
      dc.drawLine(x10, y5, x11, y5);
    }

    //Дполнительное поле справа снизу под циферблатом
    var y3 = y4 - Math.floor(Global.mod(y5 - y4) * 0.7);
    interseption = calculateHorizontalIntersection(dc, y3);
    var x7 = interseption[1];
    var x4 = Math.floor(0.7 * dc.getWidth());
    var x3 = x4;
    for (var i = 0; i < colors.size(); i++) {
      dc.setColor(colors[i], colors[i]);
      dc.setPenWidth(pen_widths[i]);
      //Косая черта
      dc.drawLine(x3, y3, x4, y4);
      //Горизонтальная черта
      dc.drawLine(x3, y3, x7, y3);
    }

    return {
      :x => [0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11],
      :y => [0, y1, y2, y3, y4, y5],
      :pen_width => pen_widths[0],
      :half_pen_width => Math.floor(pen_widths[0]),
    };
  }

  function calculateHorizontalIntersection(dc, y_level) {
    var r = dc.getWidth() / 2;
    var center = [dc.getWidth() / 2 - 1, dc.getHeight() / 2 - 1];
    var h = Global.mod(center[1] - y_level);
    var center_offset = Math.floor(Math.sqrt(r * r - h * h));
    var res = [center[0] - center_offset, center[0] + center_offset];

    // dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_RED);
    // dc.fillCircle(res[0], y_level, 5);
    // dc.fillCircle(res[1], y_level, 5);

    return res;
  }

  function calculateLayerCoordinates(left_up, right_bottom) {
    var x = calculateLayerLeft(left_up[0]);
    var y = calculateLayerUp(left_up[1]);
    var w = calculateLayerWidth(left_up[0], right_bottom[0]);
    var h = calculateLayerHeight(left_up[1], right_bottom[1]);

    return {
      :locX => x.toNumber(),
      :locY => y.toNumber(),
      :width => w.toNumber(),
      :height => h.toNumber(),
    };
  }

  function calculateLayerHeight(y1, y2) {
    return Global.mod(y1 - y2) - reference_points[:pen_width] - 3;
  }

  function calculateLayerWidth(x1, x2) {
    return Global.mod(x1 - x2) - 2;
  }

  function calculateLayerUp(y) {
    return y + reference_points[:half_pen_width] + 1;
  }

  function calculateLayerLeft(x) {
    return x + 1;
  }
}
