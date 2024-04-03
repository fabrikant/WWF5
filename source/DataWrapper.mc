import Toybox.System;
import Toybox.Math;
import Toybox.Complications;
import Toybox.Lang;
import Toybox.ActivityMonitor;

module DataWrapper {
  enum {
    EMPTY = 0,
    CALORIES,
    DISTANCE,
    STEPS,
    BATTERY,
  }

  function getData(type) {
    var res = { :value => null, :label => null, :image => null };

    if (type == CALORIES) {
      res[:value] = getCalories();
      res[:image] = Rez.Drawables.Callory;
      res[:label] = Rez.Strings.FIELD_TYPE_CALORIES;
    } else if (type == DISTANCE) {
      res[:value] = getDistance();
      res[:image] = Rez.Drawables.Distance;
      res[:label] = Rez.Strings.FIELD_TYPE_DISTANCE;
    } else if (type == STEPS) {
      res[:value] = getSteps();
      res[:image] = Rez.Drawables.Steps;
      res[:label] = Rez.Strings.FIELD_TYPE_STEPS;
    } else if (type == BATTERY) {
      res[:scale_value] = getBattery();
      res[:value] = res[:scale_value].toString()+"%";
      res[:image] = Rez.Drawables.Battery;
      res[:label] = Rez.Strings.FIELD_TYPE_BATTERY;
    }

    return res;
  }

  ////////////////////////////////////////////////////////
  //DATA VALUES

  function getBattery() {
    return Math.floor(System.getSystemStats().battery).toNumber();
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
