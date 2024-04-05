using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Math;

class ColorPicker extends WatchUi.View {
  var color;
  var bitmap, boxes, zero_point;

  function initialize(color) {
    View.initialize();
    self.color = color;
    createBitmap();
  }

  function onUpdate(dc) {
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    dc.clear();
    dc.drawBitmap(zero_point[0], zero_point[1], bitmap.get());

    for (var i = 0; i < boxes.size(); i++) {
      if (boxes[i][:color] == color) {
        var box = boxes[i][:box];
        dc.setPenWidth(3);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.drawRectangle(
          box[:x1] + zero_point[0],
          box[:y1] + zero_point[1],
          box[:x2] - box[:x1],
          box[:y2] - box[:y1]
        );
        dc.setPenWidth(1);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.drawRectangle(
          box[:x1] + zero_point[0],
          box[:y1] + zero_point[1],
          box[:x2] - box[:x1],
          box[:y2] - box[:y1]
        );
        break;
      }
    }
  }

  function createBitmap() {
    boxes = [];
    var rows = 8;
    var dev_screen_size = System.getDeviceSettings().screenHeight;
    var side_size = Math.floor(
      Math.sqrt((dev_screen_size * dev_screen_size) / 2)
    );
    var segment_size = Math.floor(side_size / rows).toNumber();
    side_size = segment_size * rows;

    var zero = (dev_screen_size - side_size) / 2;
    zero_point = [zero, zero];

    var x_count = 0;
    var y_count = 0;

    self.bitmap = Graphics.createBufferedBitmap({
      :width => side_size,
      :height => side_size + 2 * segment_size,
    });
    var dc = bitmap.get().getDc();

    var values = [0x00, 0x55, 0xaa, 0xff];
    for (var i = 0; i < values.size(); i++) {
      for (var j = 0; j < values.size(); j++) {
        for (var k = 0; k < values.size(); k++) {
          var curren_color = (values[i] << 16) + (values[j] << 8) + values[k];
          var x = x_count * segment_size;
          var y = y_count * segment_size;
          dc.setColor(curren_color, curren_color);
          dc.fillRectangle(x, y, segment_size, segment_size);

          boxes.add({
            :color => curren_color,
            :box => {
              :x1 => x,
              :y1 => y,
              :x2 => x + segment_size,
              :y2 => y + segment_size,
            },
          });
          if ((x_count + 1) % rows == 0) {
            x_count = 0;
            y_count += 1;
          } else {
            x_count += 1;
          }
          if (y_count >= rows) {
            break;
          }
        }
      }
    }
    boxes.add({
      :color => Graphics.COLOR_TRANSPARENT,
      :box => {
        :x1 => segment_size * 2,
        :y1 => side_size,
        :x2 => side_size - segment_size * 2,
        :y2 => dc.getHeight(),
      },
    });

    var box = boxes[boxes.size() - 1][:box];
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
    dc.setClip(box[:x1], box[:y1], box[:x2] - box[:x1], box[:y2] - box[:y1]);
    dc.fillRectangle(
      box[:x1],
      box[:y1],
      box[:x2] - box[:x1],
      box[:y2] - box[:y1]
    );
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    dc.setPenWidth(5);
    dc.drawLine(box[:x1], box[:y1], box[:x2], box[:y2]);
    dc.drawLine(box[:x2], box[:y1], box[:x1], box[:y2]);

    // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
    // dc.setPenWidth(1);
    // dc.drawRectangle(0, 0, dc.getWidth(), dc.getHeight());
  }

  function onClick(clickEvent) {
    var coords = clickEvent.getCoordinates();
    coords[0] -= zero_point[0];
    coords[1] -= zero_point[1];
    for (var i = 0; i < boxes.size(); i++) {
      var box = boxes[i][:box];
      if (
        coords[0] >= box[:x1] &&
        coords[0] < box[:x2] &&
        coords[1] >= box[:y1] &&
        coords[1] < box[:y2]
      ) {
        color = boxes[i][:color];
        WatchUi.requestUpdate();
        break;
      }
    }
  }

  function onKey(keyEvent){

    var key = keyEvent.getKey();
    System.println(key);
  }
}

class ColorPickerDelegate extends WatchUi.InputDelegate {
  var picker_weak;

  function initialize(picker_weak) {
    InputDelegate.initialize();
    self.picker_weak = picker_weak;
  }

  function onKey(keyEvent) {
    if (picker_weak.stillAlive()) {
      var obj = picker_weak.get();
      if (obj != null) {
        obj.onKey(keyEvent);
      }
    }
    return true;
  }

  function onTap(clickEvent) {
    if (picker_weak.stillAlive()) {
      var obj = picker_weak.get();
      if (obj != null) {
        obj.onClick(clickEvent);
      }
    }
    return true;
  }
}
