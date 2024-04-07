import Toybox.Graphics;
import Toybox.System;
import Toybox.Weather;
import Toybox.Application;
import Toybox.Math;
import Toybox.Time;
import Toybox.Complications;

class WeatherWidget extends AbstractField {
  var arrow_bitmap;

  function initialize(options) {
    AbstractField.initialize(options);
    arrow_bitmap = null;
    compl_id = new Complications.Id(Complications.COMPLICATION_TYPE_CURRENT_WEATHER);
  }

  function draw(colors) {
    AbstractField.draw(colors);
    var weather = Weather.getCurrentConditions();
    if (weather == null) {
      drawBorder(getDc());
      return;
    }
    var dc = getDc();

    //Иконка погоды
    var bitmap = createImage(getGarminConditionRez(weather), colors);
    var temp_x = dc.getWidth() * 0.08;
    dc.drawBitmap(temp_x, (dc.getHeight() - bitmap.getHeight()) / 2, bitmap);

    //Температура
    var fontTemp = getApp().watch_view.fontTemp;
    temp_x += bitmap.getWidth();
    var max_temp_width = dc.getTextWidthInPixels("0", fontTemp) * 3;
    var temperature = DataWrapper.convertTemperature(weather.temperature);
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

    //Ветер
    var font_wind = Graphics.getVectorFont({
      :face => vectorFontName(),
      :size => 0.75 * Graphics.getFontHeight(getApp().watch_view.fontValues),
    });
    var wind_speed = DataWrapper.converValueWindSpeed(weather.windSpeed);
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
    var wind_angle = weather.windBearing;
    if (arrow_bitmap == null) {
      var bitmap_size = Math.floor(bitmap.getHeight() * 0.65);
      arrow_bitmap = getWindArrowBitmap(bitmap_size, colors);
    }

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

    drawBorder(dc);
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
    dc.setColor(colors[:font], colors[:font]);
    dc.fillPolygon(coords);

    return buf_bitmap_ref;
  }

  function getGarminConditionRez(weather) {
    var condition = weather.condition;
    var isDay = true;
    var moment_now = Time.now();

    if (weather.observationLocationPosition != null) {
      var sunrise = Weather.getSunrise(
        weather.observationLocationPosition,
        moment_now
      );
      var sunset = Weather.getSunset(
        weather.observationLocationPosition,
        moment_now
      );
      if (sunrise != null && sunset != null) {
        if (
          moment_now.lessThan(sunrise) ||
          weather.observationTime.greaterThan(sunset)
        ) {
          isDay = false;
        }
      }
    }

    if (isDay) {
      if (condition == Weather.CONDITION_CLEAR) {
        return Rez.Drawables.CONDITION_CLEAR;
      } else if (condition == Weather.CONDITION_PARTLY_CLOUDY) {
        return Rez.Drawables.CONDITION_PARTLY_CLOUDY;
      } else if (condition == Weather.CONDITION_MOSTLY_CLOUDY) {
        return Rez.Drawables.CONDITION_MOSTLY_CLOUDY;
      } else if (condition == Weather.CONDITION_RAIN) {
        return Rez.Drawables.CONDITION_RAIN;
      } else if (condition == Weather.CONDITION_SNOW) {
        return Rez.Drawables.CONDITION_SNOW;
      } else if (condition == Weather.CONDITION_WINDY) {
        return Rez.Drawables.CONDITION_WINDY;
      } else if (condition == Weather.CONDITION_THUNDERSTORMS) {
        return Rez.Drawables.CONDITION_THUNDERSTORMS;
      } else if (condition == Weather.CONDITION_WINTRY_MIX) {
        return Rez.Drawables.CONDITION_WINTRY_MIX;
      } else if (condition == Weather.CONDITION_FOG) {
        return Rez.Drawables.CONDITION_FOG;
      } else if (condition == Weather.CONDITION_HAZY) {
        return Rez.Drawables.CONDITION_HAZY;
      } else if (condition == Weather.CONDITION_HAIL) {
        return Rez.Drawables.CONDITION_HAIL;
      } else if (condition == Weather.CONDITION_SCATTERED_SHOWERS) {
        return Rez.Drawables.CONDITION_SCATTERED_SHOWERS;
      } else if (condition == Weather.CONDITION_SCATTERED_THUNDERSTORMS) {
        return Rez.Drawables.CONDITION_SCATTERED_THUNDERSTORMS;
      } else if (condition == Weather.CONDITION_UNKNOWN_PRECIPITATION) {
        return Rez.Drawables.CONDITION_UNKNOWN_PRECIPITATION;
      } else if (condition == Weather.CONDITION_LIGHT_RAIN) {
        return Rez.Drawables.CONDITION_LIGHT_RAIN;
      } else if (condition == Weather.CONDITION_HEAVY_RAIN) {
        return Rez.Drawables.CONDITION_HEAVY_RAIN;
      } else if (condition == Weather.CONDITION_LIGHT_SNOW) {
        return Rez.Drawables.CONDITION_LIGHT_SNOW;
      } else if (condition == Weather.CONDITION_HEAVY_SNOW) {
        return Rez.Drawables.CONDITION_HEAVY_SNOW;
      } else if (condition == Weather.CONDITION_LIGHT_RAIN_SNOW) {
        return Rez.Drawables.CONDITION_LIGHT_RAIN_SNOW;
      } else if (condition == Weather.CONDITION_HEAVY_RAIN_SNOW) {
        return Rez.Drawables.CONDITION_HEAVY_RAIN_SNOW;
      } else if (condition == Weather.CONDITION_CLOUDY) {
        return Rez.Drawables.CONDITION_CLOUDY;
      } else if (condition == Weather.CONDITION_RAIN_SNOW) {
        return Rez.Drawables.CONDITION_RAIN_SNOW;
      } else if (condition == Weather.CONDITION_PARTLY_CLEAR) {
        return Rez.Drawables.CONDITION_PARTLY_CLEAR;
      } else if (condition == Weather.CONDITION_MOSTLY_CLEAR) {
        return Rez.Drawables.CONDITION_MOSTLY_CLEAR;
      } else if (condition == Weather.CONDITION_LIGHT_SHOWERS) {
        return Rez.Drawables.CONDITION_LIGHT_SHOWERS;
      } else if (condition == Weather.CONDITION_SHOWERS) {
        return Rez.Drawables.CONDITION_SHOWERS;
      } else if (condition == Weather.CONDITION_HEAVY_SHOWERS) {
        return Rez.Drawables.CONDITION_HEAVY_SHOWERS;
      } else if (condition == Weather.CONDITION_CHANCE_OF_SHOWERS) {
        return Rez.Drawables.CONDITION_CHANCE_OF_SHOWERS;
      } else if (condition == Weather.CONDITION_CHANCE_OF_THUNDERSTORMS) {
        return Rez.Drawables.CONDITION_CHANCE_OF_THUNDERSTORMS;
      } else if (condition == Weather.CONDITION_MIST) {
        return Rez.Drawables.CONDITION_MIST;
      } else if (condition == Weather.CONDITION_DUST) {
        return Rez.Drawables.CONDITION_DUST;
      } else if (condition == Weather.CONDITION_DRIZZLE) {
        return Rez.Drawables.CONDITION_DRIZZLE;
      } else if (condition == Weather.CONDITION_TORNADO) {
        return Rez.Drawables.CONDITION_TORNADO;
      } else if (condition == Weather.CONDITION_SMOKE) {
        return Rez.Drawables.CONDITION_SMOKE;
      } else if (condition == Weather.CONDITION_ICE) {
        return Rez.Drawables.CONDITION_ICE;
      } else if (condition == Weather.CONDITION_SAND) {
        return Rez.Drawables.CONDITION_SAND;
      } else if (condition == Weather.CONDITION_SQUALL) {
        return Rez.Drawables.CONDITION_SQUALL;
      } else if (condition == Weather.CONDITION_SANDSTORM) {
        return Rez.Drawables.CONDITION_SANDSTORM;
      } else if (condition == Weather.CONDITION_VOLCANIC_ASH) {
        return Rez.Drawables.CONDITION_VOLCANIC_ASH;
      } else if (condition == Weather.CONDITION_HAZE) {
        return Rez.Drawables.CONDITION_HAZE;
      } else if (condition == Weather.CONDITION_FAIR) {
        return Rez.Drawables.CONDITION_FAIR;
      } else if (condition == Weather.CONDITION_HURRICANE) {
        return Rez.Drawables.CONDITION_HURRICANE;
      } else if (condition == Weather.CONDITION_TROPICAL_STORM) {
        return Rez.Drawables.CONDITION_TROPICAL_STORM;
      } else if (condition == Weather.CONDITION_CHANCE_OF_SNOW) {
        return Rez.Drawables.CONDITION_CHANCE_OF_SNOW;
      } else if (condition == Weather.CONDITION_CHANCE_OF_RAIN_SNOW) {
        return Rez.Drawables.CONDITION_CHANCE_OF_RAIN_SNOW;
      } else if (condition == Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN) {
        return Rez.Drawables.CONDITION_CLOUDY_CHANCE_OF_RAIN;
      } else if (condition == Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW) {
        return Rez.Drawables.CONDITION_CLOUDY_CHANCE_OF_SNOW;
      } else if (condition == Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW) {
        return Rez.Drawables.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW;
      } else if (condition == Weather.CONDITION_FLURRIES) {
        return Rez.Drawables.CONDITION_FLURRIES;
      } else if (condition == Weather.CONDITION_FREEZING_RAIN) {
        return Rez.Drawables.CONDITION_FREEZING_RAIN;
      } else if (condition == Weather.CONDITION_SLEET) {
        return Rez.Drawables.CONDITION_SLEET;
      } else if (condition == Weather.CONDITION_ICE_SNOW) {
        return Rez.Drawables.CONDITION_ICE_SNOW;
      } else if (condition == Weather.CONDITION_THIN_CLOUDS) {
        return Rez.Drawables.CONDITION_THIN_CLOUDS;
      } else if (condition == Weather.CONDITION_UNKNOWN) {
        return Rez.Drawables.CONDITION_UNKNOWN;
      }
    } else {
      if (condition == Weather.CONDITION_CLEAR) {
        return Rez.Drawables.CONDITION_CLEAR_NIGHT;
      } else if (condition == Weather.CONDITION_PARTLY_CLOUDY) {
        return Rez.Drawables.CONDITION_PARTLY_CLOUDY_NIGHT;
      } else if (condition == Weather.CONDITION_MOSTLY_CLOUDY) {
        return Rez.Drawables.CONDITION_MOSTLY_CLOUDY_NIGHT;
      } else if (condition == Weather.CONDITION_RAIN) {
        return Rez.Drawables.CONDITION_RAIN_NIGHT;
      } else if (condition == Weather.CONDITION_SNOW) {
        return Rez.Drawables.CONDITION_SNOW_NIGHT;
      } else if (condition == Weather.CONDITION_WINDY) {
        return Rez.Drawables.CONDITION_WINDY_NIGHT;
      } else if (condition == Weather.CONDITION_THUNDERSTORMS) {
        return Rez.Drawables.CONDITION_THUNDERSTORMS_NIGHT;
      } else if (condition == Weather.CONDITION_WINTRY_MIX) {
        return Rez.Drawables.CONDITION_WINTRY_MIX_NIGHT;
      } else if (condition == Weather.CONDITION_FOG) {
        return Rez.Drawables.CONDITION_FOG_NIGHT;
      } else if (condition == Weather.CONDITION_HAZY) {
        return Rez.Drawables.CONDITION_HAZY_NIGHT;
      } else if (condition == Weather.CONDITION_HAIL) {
        return Rez.Drawables.CONDITION_HAIL_NIGHT;
      } else if (condition == Weather.CONDITION_SCATTERED_SHOWERS) {
        return Rez.Drawables.CONDITION_SCATTERED_SHOWERS_NIGHT;
      } else if (condition == Weather.CONDITION_SCATTERED_THUNDERSTORMS) {
        return Rez.Drawables.CONDITION_SCATTERED_THUNDERSTORMS_NIGHT;
      } else if (condition == Weather.CONDITION_UNKNOWN_PRECIPITATION) {
        return Rez.Drawables.CONDITION_UNKNOWN_PRECIPITATION_NIGHT;
      } else if (condition == Weather.CONDITION_LIGHT_RAIN) {
        return Rez.Drawables.CONDITION_LIGHT_RAIN_NIGHT;
      } else if (condition == Weather.CONDITION_HEAVY_RAIN) {
        return Rez.Drawables.CONDITION_HEAVY_RAIN_NIGHT;
      } else if (condition == Weather.CONDITION_LIGHT_SNOW) {
        return Rez.Drawables.CONDITION_LIGHT_SNOW_NIGHT;
      } else if (condition == Weather.CONDITION_HEAVY_SNOW) {
        return Rez.Drawables.CONDITION_HEAVY_SNOW_NIGHT;
      } else if (condition == Weather.CONDITION_LIGHT_RAIN_SNOW) {
        return Rez.Drawables.CONDITION_LIGHT_RAIN_SNOW_NIGHT;
      } else if (condition == Weather.CONDITION_HEAVY_RAIN_SNOW) {
        return Rez.Drawables.CONDITION_HEAVY_RAIN_SNOW_NIGHT;
      } else if (condition == Weather.CONDITION_CLOUDY) {
        return Rez.Drawables.CONDITION_CLOUDY_NIGHT;
      } else if (condition == Weather.CONDITION_RAIN_SNOW) {
        return Rez.Drawables.CONDITION_RAIN_SNOW_NIGHT;
      } else if (condition == Weather.CONDITION_PARTLY_CLEAR) {
        return Rez.Drawables.CONDITION_PARTLY_CLEAR_NIGHT;
      } else if (condition == Weather.CONDITION_MOSTLY_CLEAR) {
        return Rez.Drawables.CONDITION_MOSTLY_CLEAR_NIGHT;
      } else if (condition == Weather.CONDITION_LIGHT_SHOWERS) {
        return Rez.Drawables.CONDITION_LIGHT_SHOWERS_NIGHT;
      } else if (condition == Weather.CONDITION_SHOWERS) {
        return Rez.Drawables.CONDITION_SHOWERS_NIGHT;
      } else if (condition == Weather.CONDITION_HEAVY_SHOWERS) {
        return Rez.Drawables.CONDITION_HEAVY_SHOWERS_NIGHT;
      } else if (condition == Weather.CONDITION_CHANCE_OF_SHOWERS) {
        return Rez.Drawables.CONDITION_CHANCE_OF_SHOWERS_NIGHT;
      } else if (condition == Weather.CONDITION_CHANCE_OF_THUNDERSTORMS) {
        return Rez.Drawables.CONDITION_CHANCE_OF_THUNDERSTORMS_NIGHT;
      } else if (condition == Weather.CONDITION_MIST) {
        return Rez.Drawables.CONDITION_MIST_NIGHT;
      } else if (condition == Weather.CONDITION_DUST) {
        return Rez.Drawables.CONDITION_DUST_NIGHT;
      } else if (condition == Weather.CONDITION_DRIZZLE) {
        return Rez.Drawables.CONDITION_DRIZZLE_NIGHT;
      } else if (condition == Weather.CONDITION_TORNADO) {
        return Rez.Drawables.CONDITION_TORNADO_NIGHT;
      } else if (condition == Weather.CONDITION_SMOKE) {
        return Rez.Drawables.CONDITION_SMOKE_NIGHT;
      } else if (condition == Weather.CONDITION_ICE) {
        return Rez.Drawables.CONDITION_ICE_NIGHT;
      } else if (condition == Weather.CONDITION_SAND) {
        return Rez.Drawables.CONDITION_SAND_NIGHT;
      } else if (condition == Weather.CONDITION_SQUALL) {
        return Rez.Drawables.CONDITION_SQUALL_NIGHT;
      } else if (condition == Weather.CONDITION_SANDSTORM) {
        return Rez.Drawables.CONDITION_SANDSTORM_NIGHT;
      } else if (condition == Weather.CONDITION_VOLCANIC_ASH) {
        return Rez.Drawables.CONDITION_VOLCANIC_ASH_NIGHT;
      } else if (condition == Weather.CONDITION_HAZE) {
        return Rez.Drawables.CONDITION_HAZE_NIGHT;
      } else if (condition == Weather.CONDITION_FAIR) {
        return Rez.Drawables.CONDITION_FAIR_NIGHT;
      } else if (condition == Weather.CONDITION_HURRICANE) {
        return Rez.Drawables.CONDITION_HURRICANE_NIGHT;
      } else if (condition == Weather.CONDITION_TROPICAL_STORM) {
        return Rez.Drawables.CONDITION_TROPICAL_STORM_NIGHT;
      } else if (condition == Weather.CONDITION_CHANCE_OF_SNOW) {
        return Rez.Drawables.CONDITION_CHANCE_OF_SNOW_NIGHT;
      } else if (condition == Weather.CONDITION_CHANCE_OF_RAIN_SNOW) {
        return Rez.Drawables.CONDITION_CHANCE_OF_RAIN_SNOW_NIGHT;
      } else if (condition == Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN) {
        return Rez.Drawables.CONDITION_CLOUDY_CHANCE_OF_RAIN_NIGHT;
      } else if (condition == Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW) {
        return Rez.Drawables.CONDITION_CLOUDY_CHANCE_OF_SNOW_NIGHT;
      } else if (condition == Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW) {
        return Rez.Drawables.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW_NIGHT;
      } else if (condition == Weather.CONDITION_FLURRIES) {
        return Rez.Drawables.CONDITION_FLURRIES_NIGHT;
      } else if (condition == Weather.CONDITION_FREEZING_RAIN) {
        return Rez.Drawables.CONDITION_FREEZING_RAIN_NIGHT;
      } else if (condition == Weather.CONDITION_SLEET) {
        return Rez.Drawables.CONDITION_SLEET_NIGHT;
      } else if (condition == Weather.CONDITION_ICE_SNOW) {
        return Rez.Drawables.CONDITION_ICE_SNOW_NIGHT;
      } else if (condition == Weather.CONDITION_THIN_CLOUDS) {
        return Rez.Drawables.CONDITION_THIN_CLOUDS_NIGHT;
      } else if (condition == Weather.CONDITION_UNKNOWN) {
        return Rez.Drawables.CONDITION_UNKNOWN_NIGHT;
      }
    }
  }
}
