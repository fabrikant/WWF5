import Toybox.Graphics;
import Toybox.System;
import Toybox.Weather;
import Toybox.Application;
import Toybox.Math;
import Toybox.Time;
import Toybox.Complications;
import Toybox.Lang;

class WeatherWidget extends AbstractField {
  var arrow_bitmap;
  var weather_condition;

  function initialize(options) {
    AbstractField.initialize(options);
    arrow_bitmap = null;
    compl_id = new Complications.Id(
      Complications.COMPLICATION_TYPE_CURRENT_WEATHER
    );
    weather_condition = WeatherWrapper.getCurrentConditions();
  }

  function draw(colors) {
    AbstractField.draw(colors);
    weather_condition.updateValues();
    if (weather_condition.data_source == null) {
      drawBorder(getDc());
      return;
    }
    var dc = getDc();

    ///////////////////////////////////////////////////////////////////////////
    //Иконка погоды
    var bitmap = createImage(weather_condition.icon_rez, colors);
    var temp_x = dc.getWidth() * 0.08;
    dc.drawBitmap(temp_x, (dc.getHeight() - bitmap.getHeight()) / 2, bitmap);

    ///////////////////////////////////////////////////////////////////////////
    //Температура
    var fontTemp = getApp().watch_view.fontTemp;
    temp_x += bitmap.getWidth();
    var max_temp_width = dc.getTextWidthInPixels("0", fontTemp) * 3;
    var temperature = DataWrapper.convertTemperature(
      weather_condition.temperature
    );
    var temperature_y = Math.floor(dc.getHeight() / 2);
    drawText(
      dc,
      colors,
      temp_x + max_temp_width / 2,
      temperature_y,
      fontTemp,
      temperature,
      Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
    );

    //"°" symbol
    var temperature_font_height = Graphics.getFontHeight(fontTemp);
    var radius_symbol = temperature_font_height / 12;
    var x_symbol =
      temp_x +
      max_temp_width / 2 +
      dc.getTextWidthInPixels(temperature, fontTemp) / 2;
    var temp_y = temperature_y - temperature_font_height / 4;
    dc.setPenWidth(2);
    dc.drawCircle(x_symbol + 2 * radius_symbol, temp_y, radius_symbol);

    temp_x += max_temp_width * 1.25;

    ///////////////////////////////////////////////////////////////////////////
    //Ветер
    var font_wind = Graphics.getVectorFont({
      :face => vectorFontName(),
      :size => 0.75 * Graphics.getFontHeight(getApp().watch_view.fontValues),
    });
    var wind_speed = DataWrapper.converValueWindSpeed(
      weather_condition.windSpeed
    );
    var system_radius = System.getDeviceSettings().screenHeight / 2;
    var radius = Math.floor(
      (System.getDeviceSettings().screenHeight -
        Graphics.getFontHeight(font_wind)) /
        2
    );

    //Ветер скорость
    var sin_angle =
      (system_radius - getY() - dc.getHeight()).toFloat() / system_radius;
    var angle = Math.toDegrees(Math.asin(sin_angle)) + 10;
    dc.setColor(colors[:font], colors[:background]);
    dc.drawRadialText(
      system_radius - getX(),
      dc.getHeight() + Global.mod(system_radius - (getY() + dc.getHeight())),
      font_wind,
      wind_speed,
      Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER,
      angle,
      radius,
      Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE
    );

    //Ветер направление
    var wind_angle = weather_condition.windBearing;
    if (wind_angle != null) {
      if (arrow_bitmap == null) {
        var bitmap_size = Math.floor(bitmap.getHeight() * 0.65);
        arrow_bitmap = getWindArrowBitmap(bitmap_size, colors);
      }

      if (arrow_bitmap instanceof Graphics.BufferedBitmapReference) {
        var transform = new Graphics.AffineTransform();
        transform.rotate((2 * Math.PI * (wind_angle + 180)) / 360f);
        transform.translate(
          (-arrow_bitmap.getWidth() / 2).toNumber(),
          (-arrow_bitmap.getHeight() / 2).toNumber()
        );
        temp_y = dc.getHeight() - arrow_bitmap.getHeight() / 2;
        dc.drawBitmap2(temp_x, temp_y, arrow_bitmap, {
          :transform => transform,
          :filterMode => Graphics.FILTER_MODE_BILINEAR,
        });
      }
    }

    if (Application.Properties.getValue("show_w_source")) {
      drawWeatherDataSource(dc, colors);
    }
    drawBorder(dc);
  }

  private function drawWeatherDataSource(dc, colors) {
    //return;
    dc.setColor(colors[:font], colors[:background]);
    var font = Graphics.getVectorFont({
      :face => vectorFontName(),
      :size => 0.5 * Graphics.getFontHeight(getApp().watch_view.fontValues),
    });
    var weather_source = "OWM";
    if (weather_condition.data_source == :garmin) {
      weather_source = "GAR";
    }
    dc.drawText(
      dc.getWidth() * 0.1,
      dc.getHeight() - Graphics.getFontAscent(font),
      font,
      Lang.format("$1$ $2$", [
        weather_source,
        DataWrapper.momentToString(weather_condition.observationTime),
      ]),
      Graphics.TEXT_JUSTIFY_LEFT
    );
  }

  private function getWindArrowBitmap(size, colors) {
    var coords = [
      [0, size / 2],
      [size / 4, size / 2],
      [size / 4, size],
      [size / 2, size],
      [size / 2, size / 2],
      [(size * 3) / 4, size / 2],
      [(size * 3) / 8, 0],
    ];

    var buf_bitmap_ref = Graphics.createBufferedBitmap({
      :width => (size * 3) / 4,
      :height => size,
    });
    var dc = buf_bitmap_ref.get().getDc();
    dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
    dc.clear();
    dc.setColor(colors[:image], colors[:image]);
    dc.fillPolygon(coords);

    return buf_bitmap_ref;
  }
}
