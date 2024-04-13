import Toybox.System;
import Toybox.Math;
import Toybox.Complications;
import Toybox.Lang;
import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.Application;
import Toybox.SensorHistory;
import Toybox.Time;
import Toybox.UserProfile;
import Toybox.Weather;

module DataWrapper {
  enum {
    EMPTY = 0,
    HR,
    CALORIES_TOTAL,
    CALORIES_ACTIVE,
    STEPS,
    DISTANCE,
    WEEKLY_RUN_DISTANCE,
    WEEKLY_BIKE_DISTANCE,
    INTENSITY_MINUTES,
    BODY_BATTERY,
    RECOVERY_TIME,
    STRESS,
    O2,
    VO2_RUN,
    VO2_BIKE,
    RESPIRATION_RATE,
    WEIGHT,
    FLOOR,
    ALTITUDE,
    PRESSURE,
    TEMPERATURE,
    RELATIVE_HUMIDITY,
    PRECIPITATION_CHANCE,
    MOON,
    TIME_ZONE,
    SECONDS,
    BATTERY,
    SOLAR_INPUT,
    DATE_LONG,
    DATE,
    WEEKDAY_MONTHDAY,
    CALENDAR_EVENTS,
    TRAINING_STATUS,
    CITY,

    UNIT_PRESSURE_MM_HG = 0,
    UNIT_PRESSURE_PSI,
    UNIT_PRESSURE_INCH_HG,
    UNIT_PRESSURE_BAR,
    UNIT_PRESSURE_KPA,
  }

  function getData(type) {
    var res = { :value => null, :label => null, :image => null };

    if (type == CALORIES_ACTIVE) {
      res = getNativeComplicationData(
        Complications.COMPLICATION_TYPE_CALORIES,
        null
      );
      res[:image] = Rez.Drawables.Callory;
    } else if (type == CALORIES_TOTAL) {
      res[:value] = getCalories();
      res[:label] = Rez.Strings.FIELD_TYPE_CALORIES_TOTAL;
      res[:image] = Rez.Drawables.Callory;
      res[:compl_id] = new Complications.Id(
        Complications.COMPLICATION_TYPE_CALORIES
      );
    } else if (type == DISTANCE) {
      res[:value] = getDistance();
      res[:image] = Rez.Drawables.Distance;
      res[:label] = Rez.Strings.FIELD_TYPE_DISTANCE;
      res[:compl_id] = new Complications.Id(
        Complications.COMPLICATION_TYPE_WEEKLY_RUN_DISTANCE
      );
    } else if (type == STEPS) {
      res = getNativeComplicationData(
        Complications.COMPLICATION_TYPE_STEPS,
        null
      );
      res[:image] = Rez.Drawables.Steps;
    } else if (type == BATTERY) {
      res = getNativeComplicationPercentData(
        Complications.COMPLICATION_TYPE_BATTERY
      );
      res[:image] = Rez.Drawables.Battery;
    } else if (type == HR) {
      res = getNativeComplicationData(
        Complications.COMPLICATION_TYPE_HEART_RATE,
        null
      );
      res[:image] = Rez.Drawables.HR;
    } else if (type == BODY_BATTERY) {
      res = getNativeComplicationPercentData(
        Complications.COMPLICATION_TYPE_BODY_BATTERY
      );
      res[:image] = Rez.Drawables.BodyBattery;
    } else if (type == RECOVERY_TIME) {
      res = getNativeComplicationData(
        Complications.COMPLICATION_TYPE_RECOVERY_TIME,
        :minutesToString
      );
      res[:image] = Rez.Drawables.RecoveryTime;
    } else if (type == FLOOR) {
      res = getNativeComplicationData(
        Complications.COMPLICATION_TYPE_FLOORS_CLIMBED,
        null
      );
      res[:image] = Rez.Drawables.Floor;
    } else if (type == O2) {
      res = getNativeComplicationPercentData(
        Complications.COMPLICATION_TYPE_PULSE_OX
      );
      res[:image] = Rez.Drawables.O2;
    } else if (type == ALTITUDE) {
      res = getNativeComplicationData(
        Complications.COMPLICATION_TYPE_ALTITUDE,
        :altitudeToString
      );
      res[:image] = Rez.Drawables.Altitude;
    } else if (type == STRESS) {
      res = getNativeComplicationData(
        Complications.COMPLICATION_TYPE_STRESS,
        null
      );
      res[:image] = Rez.Drawables.Stress;
    } else if (type == MOON) {
      res = getApp().watch_view.moon_keeper.getActulalData(Time.now());
      res[:label] = Rez.Strings.FIELD_TYPE_MOON;
    } else if (type == PRESSURE) {
      res[:value] = getPressure();
      res[:image] = Rez.Drawables.Pressure;
      res[:label] = Rez.Strings.FIELD_TYPE_PRESSURE;
      res[:compl_id] = new Complications.Id(
        Complications.COMPLICATION_TYPE_SEA_LEVEL_PRESSURE
      );
    } else if (type == TEMPERATURE) {
      res[:value] = getTemperature();
      res[:image] = Rez.Drawables.Temperature;
      res[:label] = Rez.Strings.FIELD_TYPE_TEMPERATURE;
    } else if (type == TIME_ZONE) {
      res[:value] = getSecondTime();
      res[:image] = Rez.Drawables.TimeZone;
      res[:label] = Rez.Strings.FIELD_TYPE_TIME1;
    } else if (type == WEIGHT) {
      res[:value] = getWeight();
      res[:image] = Rez.Drawables.Weight;
      res[:label] = Rez.Strings.FIELD_TYPE_WEIGHT;
    } else if (type == RELATIVE_HUMIDITY) {
      res[:scale_value] = getRelativeHumidity();
      res[:value] = getScaleValueCaption(res[:scale_value]);
      res[:image] = Rez.Drawables.RelativeHumidity;
      res[:label] = Rez.Strings.FIELD_TYPE_RELATIVE_HUMIDITY;
      res[:compl_id] = new Complications.Id(
        Complications.COMPLICATION_TYPE_CURRENT_WEATHER
      );
    } else if (type == PRECIPITATION_CHANCE) {
      res[:scale_value] = getPrecipitationChance();
      res[:value] = getScaleValueCaption(res[:scale_value]);
      res[:image] = Rez.Drawables.PrecipitationChance;
      res[:label] = Rez.Strings.FIELD_TYPE_PRECIPITATION_CHANCE;
      res[:compl_id] = new Complications.Id(
        Complications.COMPLICATION_TYPE_CURRENT_WEATHER
      );
    } else if (type == WEEKLY_RUN_DISTANCE) {
      res = getNativeComplicationData(
        Complications.COMPLICATION_TYPE_WEEKLY_RUN_DISTANCE,
        :complicationDistanceToString
      );
      res[:image] = Rez.Drawables.Run;
    } else if (type == WEEKLY_BIKE_DISTANCE) {
      res = getNativeComplicationData(
        Complications.COMPLICATION_TYPE_WEEKLY_BIKE_DISTANCE,
        :complicationDistanceToString
      );
      res[:image] = Rez.Drawables.Bike;
    } else if (type == VO2_RUN) {
      res = getNativeComplicationData(
        Complications.COMPLICATION_TYPE_VO2MAX_RUN,
        null
      );
    } else if (type == VO2_BIKE) {
      res = getNativeComplicationData(
        Complications.COMPLICATION_TYPE_VO2MAX_BIKE,
        null
      );
    } else if (type == RESPIRATION_RATE) {
      res = getNativeComplicationData(
        Complications.COMPLICATION_TYPE_RESPIRATION_RATE,
        null
      );
      res[:image] = Rez.Drawables.Blow;
    } else if (type == SOLAR_INPUT) {
      res = getNativeComplicationPercentData(
        Complications.COMPLICATION_TYPE_SOLAR_INPUT
      );
      res[:image] = Rez.Drawables.SunEnergy;
    } else if (type == INTENSITY_MINUTES) {
      res = getNativeComplicationData(
        Complications.COMPLICATION_TYPE_INTENSITY_MINUTES,
        :minutesToString
      );
      res[:image] = Rez.Drawables.Exercises;
    } else if (type == DATE_LONG) {
      res = {
        :value => getLongDate(),
        :label => Rez.Strings.FIELD_TYPE_LONG_DATE,
      };
    } else if (type == DATE) {
      res = getNativeComplicationData(
        Complications.COMPLICATION_TYPE_DATE,
        null
      );
    } else if (type == WEEKDAY_MONTHDAY) {
      res = getNativeComplicationData(
        Complications.COMPLICATION_TYPE_WEEKDAY_MONTHDAY,
        null
      );
    } else if (type == CALENDAR_EVENTS) {
      res = getNativeComplicationData(
        Complications.COMPLICATION_TYPE_CALENDAR_EVENTS,
        null
      );
      res[:image] = Rez.Drawables.Calendar;
    } else if (type == TRAINING_STATUS) {
      res = getNativeComplicationData(
        Complications.COMPLICATION_TYPE_TRAINING_STATUS,
        null
      );
    } else if (type == CITY) {
      res[:value] = getWeatherCity();
      res[:compl_id] = new Complications.Id(
        Complications.COMPLICATION_TYPE_CURRENT_WEATHER
      );
      res[:label] = Rez.Strings.FIELD_TYPE_CITY;
    }

    return res;
  }

  ////////////////////////////////////////////////////////
  //DATA VALUES

  function getWeatherCity() {
    var res = null;
    var weather = Weather.getCurrentConditions();
    if (weather != null) {
      res = weather.observationLocationName;
    }
    return res;
  }

  function getNativeComplicationPercentData(compl_type) {
    var res = {
      :scale_value => null,
      :value => null,
      :label => null,
      :compl_id => new Complications.Id(compl_type),
    };
    var compl = null;
    try {
      compl = Complications.getComplication(res[:compl_id]);
    } catch (ex) {}
    if (compl != null) {
      if (compl.value != null) {
        res[:scale_value] = compl.value;
        res[:value] = getScaleValueCaption(res[:scale_value]);
      }
      res[:label] = compl.shortLabel;
      if (res[:label] == null && compl.longLabel != null) {
        res[:label] = compl.longLabel;
      }
    }
    return res;
  }

  function getNativeComplicationData(compl_type, convertation_method_symbol) {
    var res = {
      :value => null,
      :label => null,
      :compl_id => new Complications.Id(compl_type),
    };
    if (res[:compl_id] == null) {
      return res;
    }
    var compl = null;
    try {
      compl = Complications.getComplication(res[:compl_id]);
    } catch (ex) {}
    if (compl != null) {
      if (compl.value != null) {
        if (convertation_method_symbol == null) {
          res[:value] = reduceLongValue(compl.value);
        } else {
          var method = new Lang.Method(DataWrapper, convertation_method_symbol);
          res[:value] = method.invoke(compl.value);
        }
      }
      res[:label] = compl.shortLabel;
      if (res[:label] == null && compl.longLabel != null) {
        res[:label] = compl.longLabel;
      }
    }
    return res;
  }

  function getWeight() {
    var value = UserProfile.getProfile().weight;
    if (value != null) {
      value = weightToString(value.toFloat());
    }
    return value;
  }

  function getSecondTime() {
    var offset =
      Application.Properties.getValue("T1TZ") * 60 -
      System.getClockTime().timeZoneOffset;
    return momentToString(Time.now().add(new Time.Duration(offset)));
  }

  function getTemperature() {
    var value = getLasValueSensorHistory(:getTemperatureHistory);
    if (value != null) {
      value = convertTemperature(value);
    }
    return value;
  }

  function getPressure() {
    var value = getLasValueSensorHistory(:getPressureHistory);
    if (value != null) {
      value = convertPressure(value);
    }
    return value;
  }

  function getRelativeHumidity() {
    var value = null;
    var condition = Weather.getCurrentConditions();
    if (condition != null) {
      value = condition.relativeHumidity;
    }
    return value;
  }

  function getPrecipitationChance() {
    var value = null;
    var condition = Weather.getCurrentConditions();
    if (condition != null) {
      value = condition.precipitationChance;
    }
    return value;
  }

  function getCalories() {
    var value = null;
    var info = ActivityMonitor.getInfo();
    if (info has :calories) {
      value = info.calories;
    }
    return reduceLongValue(value);
  }

  function getDistance() {
    var value = null;
    var info = ActivityMonitor.getInfo();
    if (info has :distance) {
      value = distanceToString(info.distance);
    }
    return value;
  }

  function getLasValueSensorHistory(methodSymbol) {
    var value = null;
    if (Toybox has :SensorHistory) {
      if (Toybox.SensorHistory has methodSymbol) {
        var iter = (new Lang.Method(Toybox.SensorHistory, methodSymbol)).invoke(
          { :period => 1, :order => SensorHistory.ORDER_NEWEST_FIRST }
        );
        if (iter != null) {
          var sample = iter.next();
          if (sample != null) {
            if (sample.data != null) {
              value = sample.data;
            }
          }
        }
      }
    }
    return value;
  }

  function getScaleValueCaption(value) {
    var res = null;
    if (value != null) {
      res = value.toString() + "%";
    }
    return res;
  }

  function getLongDate() {
    var now = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
    return Lang.format("$1$, $2$ $3$", [now.day_of_week, now.day, now.month]);
  }

  //******************************************************
  //convertation values
  function momentToString(moment) {
    var greg = Time.Gregorian.info(moment, Time.FORMAT_SHORT);
    var hours = greg.hour;
    var hourFormat = "%02d";
    if (!System.getDeviceSettings().is24Hour) {
      hourFormat = "%d";
      if (hours > 12) {
        hours = hours - 12;
      }
    }
    return Lang.format("$1$:$2$", [
      hours.format(hourFormat),
      greg.min.format("%02d"),
    ]);
  }

  function weightToString(value) {
    if (System.getDeviceSettings().weightUnits == System.UNIT_STATUTE) {
      value *= 0.00220462;
    } else {
      value /= 1000;
    }
    return reduceLongValue(value);
  }

  function speedToString(value) {
    if (System.getDeviceSettings().paceUnits == System.UNIT_STATUTE) {
      /*foot*/
      value *= 3.281;
    }
    return reduceLongValue(value);
  }

  function altitudeToString(value) {
    if (System.getDeviceSettings().elevationUnits == System.UNIT_STATUTE) {
      /*foot*/
      value *= 3.281;
    }
    return reduceLongValue(value);
  }

  function minutesToString(value) {
    var res = null;
    var h = (value / 60).toNumber();
    var m = value % 60;
    if (h > 99) {
      res = Lang.format("$1$h", [h]);
    } else {
      res = Lang.format("$1$:$2$", [h.format("%02d"), m.format("%02d")]);
    }
    return res;
  }

  function complicationDistanceToString(value) {
    return distanceToString(value * 100);
  }

  function distanceToString(value) {
    if (System.getDeviceSettings().distanceUnits == System.UNIT_METRIC) {
      /*km*/
      value = value / 100000.0;
    } else {
      /*mile*/
      value = value / 160934.4;
    }
    var fString = "%.2f";
    if (value >= 10) {
      fString = "%.1f";
    }
    if (value >= 100) {
      fString = "%d";
    }
    return value.format(fString);
  }

  function convertPressure(value) {
    var rawData = value;
    var unit = Application.Properties.getValue("pressure_unit");
    if (unit == UNIT_PRESSURE_MM_HG) {
      /*MmHg*/
      value = Math.round(rawData / 133.322).format("%d");
    } else if (unit == UNIT_PRESSURE_PSI) {
      /*Psi*/
      value = (rawData.toFloat() / 6894.757).format("%.2f");
    } else if (unit == UNIT_PRESSURE_INCH_HG) {
      /*InchHg*/
      value = (rawData.toFloat() / 3386.389).format("%.2f");
    } else if (unit == UNIT_PRESSURE_BAR) {
      /*miliBar*/
      value = (rawData / 100).format("%d");
    } else if (unit == UNIT_PRESSURE_KPA) {
      /*kPa*/
      value = (rawData / 1000).format("%d");
    }
    return value;
  }

  function convertTemperature(сelsius) {
    var value;
    if (сelsius != null) {
      if (System.getDeviceSettings().temperatureUnits == System.UNIT_STATUTE) {
        /*F*/
        value = (сelsius * 9) / 5 + 32;
      } else {
        value = сelsius;
      }
    } else {
      value = "";
    }
    //return value.format("%d") + "°";
    return value.format("%d");
  }

  function converValueWindSpeed(wind_speed) {
    var value = wind_speed; //meters/sec
    if (value == null) {
      return "";
    }
    var unit_str = "";
    var unit = Application.Properties.getValue("wind_speed_unit");
    if (unit == Global.UNIT_SPEED_MS) {
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitMSec);
    } else if (unit == Global.UNIT_SPEED_KMH) {
      /*km/h*/
      value = wind_speed * 3.6;
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitKmH);
    } else if (unit == Global.UNIT_SPEED_MLH) {
      /*mile/h*/
      value = wind_speed * 2.237;
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitMileH);
    } else if (unit == Global.UNIT_SPEED_FTS) {
      /*ft/s*/
      value = wind_speed * 3.281;
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitFtSec);
    } else if (unit == Global.UNIT_SPEED_BEAUF) {
      /*Beaufort*/
      value = getBeaufort(wind_speed);
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitBeauf);
    } else if (unit == Global.UNIT_SPEED_KNOTS) {
      /*knots*/
      value = wind_speed * 1.94384;
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitKnots);
    }
    var res = "";
    try {
      res = value.format("%d") + " " + unit_str;
    } catch (ex) {}
    return res;
  }

  function getBeaufort(wind_speed) {
    if (wind_speed >= 33) {
      return 12;
    } else if (wind_speed >= 28.5) {
      return 11;
    } else if (wind_speed >= 24.5) {
      return 10;
    } else if (wind_speed >= 20.8) {
      return 9;
    } else if (wind_speed >= 17.2) {
      return 8;
    } else if (wind_speed >= 13.9) {
      return 7;
    } else if (wind_speed >= 10.8) {
      return 6;
    } else if (wind_speed >= 8) {
      return 5;
    } else if (wind_speed >= 5.5) {
      return 4;
    } else if (wind_speed >= 3.4) {
      return 3;
    } else if (wind_speed >= 1.6) {
      return 2;
    } else if (wind_speed >= 0.3) {
      return 1;
    } else {
      return 0;
    }
  }

  function reduceLongValue(value) {
    if (
      value instanceof Lang.Number ||
      value instanceof Lang.Float ||
      value instanceof Lang.Double
    ) {
      if (value > 9999) {
        value = (value / 1000).format("%.1f") + "k";
      } else {
        value = value.toString();
        if (value.substring(3, 4).equals(".")) {
          value = value.substring(0, 3);
        } else {
          value = value.substring(0, 4);
        }
      }
    }
    return value;
  }
}
