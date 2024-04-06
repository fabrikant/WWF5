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
    var data = DataWrapper.getData(Application.Properties.getValue(getId()));

    //Вывод значения
    if (data[:value] != null) {
      var center = [
        (dc.getWidth() / 2).toNumber(),
        (dc.getHeight() / 2).toNumber(),
      ];

      dc.setColor(colors[:font], colors[:background]);
      var font_value = getApp().watch_view.fontValues;
      drawText(
        dc,
        colors,
        center[0],
        center[1],
        font_value,
        data[:value],
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
      );
    }

    //drawSecondCircle(dc, colors, (dc.getWidth() * 0.11).toNumber());
    drawCecondsRectangle(dc, colors, (dc.getWidth() * 0.11).toNumber());
    drawBorder(dc);
  }

  //Rectangle
  function drawCecondsRectangle(dc, colors, line_width) {
    var sec = System.getClockTime().sec;
    var center = [
      (dc.getWidth() / 2).toNumber(),
      (dc.getHeight() / 2).toNumber(),
    ];

    var half_line = line_width / 2;

    dc.setPenWidth(line_width);
    dc.setColor(colors[:font], colors[:font]);
    dc.drawRectangle(
      half_line,
      half_line,
      dc.getWidth() - line_width,
      dc.getHeight() - line_width
    );

    if (sec == 0) {
      return;
    }

    dc.setPenWidth(line_width - 2);
    var color = colors[:font_empty_segments];
    if (color == Graphics.COLOR_TRANSPARENT) {
      color = colors[:background];
    }
    dc.setColor(color, color);
    dc.drawRectangle(
      half_line,
      half_line,
      dc.getWidth() - line_width,
      dc.getHeight() - line_width
    );

    var step_lenght = (dc.getWidth() - line_width) / 30;
    var steps = sec * 2;
    dc.setColor(colors[:font], colors[:font]);

    //Вправо
    if (steps <= 15) {
      dc.drawLine(
        dc.getWidth() / 2,
        half_line,
        dc.getWidth() / 2 + steps * step_lenght,
        half_line
      );
    } else {
      dc.drawLine(
        dc.getWidth() / 2,
        half_line,
        dc.getWidth() - half_line - 2,
        half_line
      );

      //Вниз
      steps -= 15;
      if (steps <= 30) {
        dc.drawLine(
          dc.getWidth() - half_line - 2,
          half_line,
          dc.getWidth() - half_line - 2,
          half_line + steps * step_lenght
        );
      } else {
        dc.drawLine(
          dc.getWidth() - half_line - 2,
          half_line,
          dc.getWidth() - half_line - 2,
          dc.getHeight() - half_line - 2
        );

        //Влево
        steps -= 30;
        if (steps <= 30) {
          dc.drawLine(
            dc.getWidth() - half_line - 2,
            dc.getHeight() - half_line - 2,
            dc.getWidth() - half_line - 2 - steps * step_lenght,
            dc.getHeight() - half_line - 2
          );
        } else {
          dc.drawLine(
            dc.getWidth() - half_line - 2,
            dc.getHeight() - half_line - 2,
            half_line - 1,
            dc.getHeight() - half_line - 2
          );

          //Вверх
          steps -= 30;
          if (steps <= 30) {
            dc.drawLine(
              half_line,
              dc.getHeight() - half_line - 2,
              half_line,
              dc.getHeight() - half_line - 2 - steps * step_lenght
            );
          } else {
            dc.drawLine(
              half_line,
              dc.getHeight() - half_line - 2,
              half_line,
              step_lenght
            );

            //Вправо
            steps -= 30;
            dc.drawLine(
              half_line,
              half_line,
              half_line + steps * step_lenght,
              half_line
            );
          }
        }
      }
    }
  }

  //Circle
  function drawSecondCircle(dc, colors, line_width) {
    var center = [
      (dc.getWidth() / 2).toNumber(),
      (dc.getHeight() / 2).toNumber(),
    ];

    var radius = center[0] - line_width / 2;

    dc.setPenWidth(line_width);
    dc.setColor(colors[:font], colors[:font]);
    dc.drawCircle(center[0], center[1], radius);
    dc.setPenWidth(line_width - 2);
    var color = colors[:font_empty_segments];
    if (color == Graphics.COLOR_TRANSPARENT) {
      color = colors[:background];
    }

    dc.setColor(color, color);
    dc.drawCircle(center[0], center[1], radius);

    var sec = System.getClockTime().sec;
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
