import Toybox.Graphics;
import Toybox.System;
import Toybox.Math;
import Toybox.Complications;
import Toybox.Lang;

class DataField extends AbstractField {
  var label_x, label_y, label_radius, label_angle, font_label;

  function initialize(options) {
    AbstractField.initialize(options);
    var font_height = Math.round(
      System.getDeviceSettings().screenHeight * 0.07
    ).toNumber();
    font_label = Graphics.getVectorFont({
      :face => vectorFontName(),
      :size => font_height,
    });
    if (getId().equals("data_type_1") || getId().equals("data_type_3")) {
      calculateLabelCoord();
    }
  }

  function draw(colors) {
    AbstractField.draw(colors);
    var dc = getDc();
    dc.setColor(colors[:font], colors[:background]);
    var data = DataWrapper.getData(Application.Properties.getValue(getId()));

    //Вывод значения
    if (data[:value] != null) {
      var font_value = getApp().watch_view.fonts[:sun_events];

      var x = null;
      var just = null;

      if (getId().equals("data_type_2")) {
        x = dc.getWidth() / 2;
        just = Graphics.TEXT_JUSTIFY_CENTER;
      } else {
        x = font_value.getNormalGlifWidth();
        just = Graphics.TEXT_JUSTIFY_LEFT;
        if (getX() < System.getDeviceSettings().screenWidth / 2) {
          x = dc.getWidth() - x;
          just = Graphics.TEXT_JUSTIFY_RIGHT;
        }
      }
      font_value.writeString(dc, x, 0, data[:value], just);
    }

    //draw label, decorate fields
    data[:font_label] = font_label;
    data[:colors] = colors;

    if (getId().equals("data_type_1")) {
      drawFieldLabel(data, Graphics.TEXT_JUSTIFY_RIGHT);
    } else if (getId().equals("data_type_2")) {
      decorateField2(data);
      drawField2Label(data);
    } else if (getId().equals("data_type_3")) {
      drawFieldLabel(data, Graphics.TEXT_JUSTIFY_LEFT);
    }

    drawBorder(dc);
  }

  //************************************************************
  //Draw labels

  function calculateLabelCoord() {
    var pattern = getApp().watch_view.pattern;
    var diam = System.getDeviceSettings().screenHeight;
    var dc = getDc();
    var system_radius = diam / 2;
    label_radius = dc.getHeight() * 1.93;
    if (getX() < system_radius) {
      label_angle = 267;
      label_x = dc.getWidth();
    } else {
      label_angle = 273;
      label_x = 0;
    }
    label_y = -dc.getHeight();
  }

  function drawFieldLabel(options, just) {
    if (options[:label] == null) {
      return;
    }

    var dc = getDc();
    dc.setColor(options[:colors][:font], options[:colors][:background]);
    var label = options[:label];
    if (label instanceof Lang.Number) {
      label = Application.loadResource(label);
    }

    if (label.length() > 4) {
      dc.drawRadialText(
        label_x,
        label_y,
        font_label,
        label,
        just,
        label_angle,
        label_radius,
        Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE
      );
    } else {
      var x = dc.getTextWidthInPixels("STEPS", font_label) / 2;
      if (getX() < System.getDeviceSettings().screenWidth / 2) {
        x = dc.getWidth() - x;
      }
      dc.drawText(
        x,
        dc.getHeight() - Graphics.getFontHeight(options[:font_label]),
        font_label,
        label,
        Graphics.TEXT_JUSTIFY_CENTER
      );
    }
  }

  function drawField2Label(options) {
    if (options[:label] == null) {
      return;
    }
    var dc = getDc();
    dc.setColor(options[:colors][:font], options[:colors][:background]);
    var label = options[:label];
    if (label instanceof Lang.Number) {
      label = Application.loadResource(label);
    }

    dc.drawText(
      dc.getWidth() / 2,
      dc.getHeight() - Graphics.getFontHeight(options[:font_label]),
      options[:font_label],
      label,
      Graphics.TEXT_JUSTIFY_CENTER
    );
  }

  function decorateField2(options) {
    var dc = getDc();
    //decorate field
    dc.setColor(
      options[:colors][:pattern_decorate],
      options[:colors][:pattern_decorate]
    );
    var offset = dc.getHeight() * 0.15;
    dc.drawLine(0, offset, 0, dc.getHeight() - offset);
    dc.drawLine(
      dc.getWidth() - 1,
      offset,
      dc.getWidth() - 1,
      dc.getHeight() - offset
    );
  }
}
