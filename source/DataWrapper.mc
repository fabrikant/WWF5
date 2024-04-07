import Toybox.System;
import Toybox.Math;
import Toybox.Complications;
import Toybox.Lang;
import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.Application;
import Toybox.SensorHistory;

module DataWrapper {
  enum {
    EMPTY = 0,
    CALORIES,
    DISTANCE,
    STEPS,
    BATTERY,
    HR,
    BODY_BATTERY,
    RECOVERY_TIME,
    SECONDS,
    FLOOR,
    O2,
    ELEVATION,
    STRESS,
  }

  function getData(type) {
    var res = { :value => null, :label => null, :image => null };

    if (type == CALORIES) {
      res[:value] = getCalories();
      res[:image] = Rez.Drawables.Callory;
      res[:label] = Rez.Strings.FIELD_TYPE_CALORIES;
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
      res[:value] = getSteps();
      res[:image] = Rez.Drawables.Steps;
      res[:label] = Rez.Strings.FIELD_TYPE_STEPS;
      res[:compl_id] = new Complications.Id(
        Complications.COMPLICATION_TYPE_STEPS
      );
    } else if (type == BATTERY) {
      res[:scale_value] = getBattery();
      res[:value] = getScaleValueCaption(res[:scale_value]);
      res[:image] = Rez.Drawables.Battery;
      res[:label] = Rez.Strings.FIELD_TYPE_BATTERY;
      res[:compl_id] = new Complications.Id(
        Complications.COMPLICATION_TYPE_BATTERY
      );
    } else if (type == HR) {
      res[:value] = getHR();
      res[:image] = Rez.Drawables.HR;
      res[:label] = Rez.Strings.FIELD_TYPE_HR;
      res[:compl_id] = new Complications.Id(
        Complications.COMPLICATION_TYPE_HEART_RATE
      );
    } else if (type == BODY_BATTERY) {
      res[:scale_value] = getBodyBattery();
      res[:value] = getScaleValueCaption(res[:scale_value]);
      res[:image] = Rez.Drawables.BodyBattery;
      res[:label] = Rez.Strings.FIELD_TYPE_BODY_BATTERY;
      res[:compl_id] = new Complications.Id(
        Complications.COMPLICATION_TYPE_BODY_BATTERY
      );
    } else if (type == RECOVERY_TIME) {
      res[:value] = getRecoveryTime();
      res[:image] = Rez.Drawables.RecoveryTime;
      res[:label] = Rez.Strings.FIELD_TYPE_RECOVERY_TIME;
      res[:compl_id] = new Complications.Id(
        Complications.COMPLICATION_TYPE_RECOVERY_TIME
      );
    } else if (type == FLOOR) {
      res[:value] = getFloor();
      res[:image] = Rez.Drawables.Floor;
      res[:label] = Rez.Strings.FIELD_TYPE_FLOOR;
      res[:compl_id] = new Complications.Id(
        Complications.COMPLICATION_TYPE_FLOORS_CLIMBED
      );
    } else if (type == O2) {
      res[:scale_value] = getOxygenSaturation();
      res[:value] = getScaleValueCaption(res[:scale_value]);
      res[:image] = Rez.Drawables.O2;
      res[:label] = Rez.Strings.FIELD_TYPE_O2;
      res[:compl_id] = new Complications.Id(
        Complications.COMPLICATION_TYPE_PULSE_OX
      );
    } else if (type == ELEVATION) {
      res[:value] = getElevation();
      res[:image] = Rez.Drawables.Elevation;
      res[:label] = Rez.Strings.FIELD_TYPE_ELEVATION;
      res[:compl_id] = new Complications.Id(
        Complications.COMPLICATION_TYPE_ALTITUDE
      );
    } else if (type == STRESS) {
      res[:value] = getStress();
      res[:image] = Rez.Drawables.Stress;
      res[:label] = Rez.Strings.FIELD_TYPE_STRESS;
      res[:compl_id] = new Complications.Id(
        Complications.COMPLICATION_TYPE_STRESS
      );
    }

    return res;
  }

  ////////////////////////////////////////////////////////
  //DATA VALUES
  function getStress(){
    var value = null;
    var compl = Complications.getComplication(
      new Complications.Id(Complications.COMPLICATION_TYPE_STRESS)
    );
    if (compl != null) {
      if (compl.value != null) {
        value = compl.value;
      }
    }
    if (value == null) {
      value = getLasValueSensorHistory(:getStressHistory);
    }
    if (value != null){
      value = reduceLongValue(value);
    }
    return value;
  }

  function getElevation() {
    var value = null;
    var compl = Complications.getComplication(
      new Complications.Id(Complications.COMPLICATION_TYPE_ALTITUDE)
    );
    if (compl != null) {
      if (compl.value != null) {
        value = compl.value;
      }
    }
    if (value == null) {
      var info = Activity.getActivityInfo();
      if (info != null) {
        if (info has :altitude) {
          if (info.altitude != null) {
            value = info.altitude;
          }
        }
      }
    }
    if (value != null){
      value = elevationToString(value);
    }
    return value;
  }

  function getOxygenSaturation() {
    var value = null;
    var compl = Complications.getComplication(
      new Complications.Id(Complications.COMPLICATION_TYPE_PULSE_OX)
    );
    if (compl != null) {
      if (compl.value != null) {
        value = compl.value;
      }
    }
    if (value == null) {
      var info = Activity.getActivityInfo();
      if (info != null) {
        if (info has :currentOxygenSaturation) {
          if (info.currentOxygenSaturation != null) {
            value = info.currentOxygenSaturation;
          }
        }
      }
    }
    if (value == null) {
      value = getLasValueSensorHistory(:getOxygenSaturationHistory);
    }
    return value;
  }

  function getFloor() {
    var value = null;
    var info = ActivityMonitor.getInfo();
    if (info has :floorsClimbed) {
      value =
        info.floorsClimbed.toString() + "|" + info.floorsDescended.toString();
    }
    return value;
  }

  function getRecoveryTime() {
    var res = 0;
    var compl = Complications.getComplication(
      new Complications.Id(Complications.COMPLICATION_TYPE_RECOVERY_TIME)
    );
    if (compl != null) {
      if (compl.value != null) {
        res = compl.value;
      }
    }

    var h = (res / 60).toNumber();
    var m = res % 60;
    if (h > 99) {
      res = Lang.format("$1$h", [h]);
    } else {
      res = Lang.format("$1$:$2$", [h.format("%02d"), m.format("%02d")]);
    }
    return res;
  }

  function getBodyBattery() {
    var res = null;
    var compl = Complications.getComplication(
      new Complications.Id(Complications.COMPLICATION_TYPE_BODY_BATTERY)
    );
    if (compl != null) {
      if (compl.value != null) {
        res = compl.value;
      }
    }
    if (res == null) {
      res = getLasValueSensorHistory(:getBodyBatteryHistory);
    }
    return res;
  }

  function getBattery() {
    return Math.floor(System.getSystemStats().battery).toNumber();
  }

  function getHR() {
    var value = null;
    var compl = Complications.getComplication(
      new Complications.Id(Complications.COMPLICATION_TYPE_HEART_RATE)
    );
    if (compl != null) {
      if (compl.value != null) {
        value = compl.value;
      }
    }
    if (value == null) {
      var info = Activity.getActivityInfo();
      if (info != null) {
        if (info has :currentHeartRate) {
          value = info.currentHeartRate;
        }
      }
    }
    return reduceLongValue(value);
  }

  function getSteps() {
    var value = null;
    var info = ActivityMonitor.getInfo();
    if (info has :steps) {
      value = info.steps;
    }
    return reduceLongValue(value);
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
  //******************************************************
  //convertation values

  function weightToString(value) {
    if (System.getDeviceSettings().weightUnits == System.UNIT_STATUTE) {
      /*foot*/
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

  function elevationToString(value) {
    if (System.getDeviceSettings().elevationUnits == System.UNIT_STATUTE) {
      /*foot*/
      value *= 3.281;
    }
    return reduceLongValue(value);
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

  function convertValueTemperature(сelsius) {
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
    return value.format("%d") + " " + unit_str;
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
