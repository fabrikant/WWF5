import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Time;

class CircleField extends AbstractField {
  function initialize(options) {
    AbstractField.initialize(options);
  }

  function draw(colors) {
    AbstractField.draw(colors);
    var dc = getDc();
    var data = null;
    var data_type = Application.Properties.getValue(getId());
    if (data_type == DataWrapper.SECONDS) {
      data = seconds();
      compl_id = null;
    } else {
      data = DataWrapper.getData(data_type);
      compl_id = data[:compl_id];
    }

    //Вывод значения
    if (data[:value] != null) {
      var center = [dc.getWidth() / 2, dc.getWidth() / 2];

      dc.setColor(colors[:font], colors[:background]);

      var font_value = getApp().watch_view.fontValues;
      //var font_value = Graphics.FONT_XTINY;
      dc.drawText(
        center[0],
        center[1],
        font_value,
        data[:value],
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
      );
    }

    //drawSecondCircle(dc, colors, (dc.getWidth() * 0.11));
    drawCecondsRectangle(dc, colors, dc.getWidth() * 0.11);
    drawBorder(dc);
  }

  //Rectangle
  function drawCecondsRectangle(dc, colors, line_width) {
    var sec = System.getClockTime().sec;
    var radius = dc.getWidth() / 2;

    var half_line = line_width / 2;
    var right_bottom_big = dc.getWidth() - line_width;
    dc.setPenWidth(line_width);
    dc.setColor(colors[:font], colors[:font]);
    dc.drawRectangle(half_line, half_line, right_bottom_big, right_bottom_big);

    if (sec == 0) {
      return;
    }

    dc.setPenWidth(line_width - 2);
    var color = colors[:font_empty_segments];
    if (color == Graphics.COLOR_TRANSPARENT) {
      color = colors[:background];
    }
    dc.setColor(color, color);
    dc.drawRectangle(half_line, half_line, right_bottom_big, right_bottom_big);

    var step_lenght = right_bottom_big / 30f;
    var steps = sec * 2;
    dc.setColor(colors[:font], colors[:font]);

    var right_bottom = dc.getWidth() - half_line;
    var right_bottom_1 = right_bottom - 1;
    var right_bottom_2 = right_bottom - 2;

    //Вправо
    var allowed_steps = Global.min(15, steps);
    dc.drawLine(
      radius,
      half_line,
      radius + allowed_steps * step_lenght,
      half_line
    );
    steps -= allowed_steps;

    //Вниз
    if (steps > 0) {
      allowed_steps = Global.min(30, steps);
      dc.drawLine(
        right_bottom_2,
        half_line,
        right_bottom_2,
        half_line + allowed_steps * step_lenght - 1
      );
      steps -= allowed_steps;
    }

    //Влево
    if (steps > 0) {
      allowed_steps = Global.min(30, steps);
      dc.drawLine(
        right_bottom_2,
        right_bottom_2,
        right_bottom_2 - allowed_steps * step_lenght,
        right_bottom_2
      );
      steps -= allowed_steps;
    }

    //Вверх
    if (steps > 0) {
      allowed_steps = Global.min(30, steps);
      dc.drawLine(
        half_line,
        right_bottom_1,
        half_line,
        right_bottom_1 - allowed_steps * step_lenght
      );
      steps -= allowed_steps;
    }

    //Вправо
    if (steps > 0) {
      dc.drawLine(
        half_line,
        half_line,
        half_line + steps * step_lenght,
        half_line
      );
    }
  }

  //Circle
  function drawSecondCircle(dc, colors, line_width) {
    var sec = System.getClockTime().sec;
    var center = [dc.getWidth() / 2, dc.getWidth() / 2];

    var radius = center[0] - line_width / 2;

    dc.setPenWidth(line_width);
    dc.setColor(colors[:font], colors[:font]);
    dc.drawCircle(center[0], center[1], radius);

    if (sec == 0) {
      return;
    }

    dc.setPenWidth(line_width - 2);
    var color = colors[:font_empty_segments];
    if (color == Graphics.COLOR_TRANSPARENT) {
      color = colors[:background];
    }

    dc.setColor(color, color);
    dc.drawCircle(center[0], center[1], radius);

    var degreeEnd = 90 - 6 * sec;
    dc.setColor(colors[:font], colors[:font]);
    dc.drawArc(
      center[0],
      center[1],
      radius,
      Graphics.ARC_CLOCKWISE,
      90,
      degreeEnd
    );
  }
}
