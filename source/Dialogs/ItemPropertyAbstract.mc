import Toybox.WatchUi;
// import Toybox.Application;
// import Toybox.Complications;

class ItemPropertyAbstract extends WatchUi.MenuItem {
  function initialize(label, subLabel, id, options) {
    MenuItem.initialize(label, subLabel, id, options);
  }

  function onSelectItem() {
    logger.debug("onSelectItem(" + getId() + ")");
  }

  function getCaptionFieldType(fieldType) {
    if (fieldType == DataWrapper.EMPTY) {
      return Rez.Strings.FIELD_TYPE_EMPTY;
    } else if (fieldType == DataWrapper.CALORIES_TOTAL) {
      return Rez.Strings.FIELD_TYPE_CALORIES_TOTAL;
    } else if (fieldType == DataWrapper.SUN_EVENTS) {
      return Rez.Strings.FIELD_TYPE_SUN_EVENTS;
    } else if (fieldType == DataWrapper.DISTANCE) {
      return Rez.Strings.FIELD_TYPE_DISTANCE;
    } else if (fieldType == DataWrapper.MOON) {
      return Rez.Strings.FIELD_TYPE_MOON;
    } else if (fieldType == DataWrapper.TEMPERATURE) {
      return Rez.Strings.FIELD_TYPE_TEMPERATURE;
    } else if (fieldType == DataWrapper.PRESSURE) {
      return Rez.Strings.FIELD_TYPE_PRESSURE;
    } else if (fieldType == DataWrapper.RELATIVE_HUMIDITY) {
      return Rez.Strings.FIELD_TYPE_RELATIVE_HUMIDITY;
    } else if (fieldType == DataWrapper.PRECIPITATION_CHANCE) {
      return Rez.Strings.FIELD_TYPE_PRECIPITATION_CHANCE;
    } else if (fieldType == DataWrapper.TIME_ZONE) {
      return Rez.Strings.FIELD_TYPE_TIME1;
    } else if (fieldType == DataWrapper.WEIGHT) {
      return Rez.Strings.FIELD_TYPE_WEIGHT;
    } else if (fieldType == DataWrapper.FEELS_LIKE_TEMPERATURE) {
      return Rez.Strings.FIELD_TYPE_FEELS_LIKE_TEMPERATURE;
    } else if (fieldType == DataWrapper.DATE_TO_DATA_FIELD) {
      return Rez.Strings.FIELD_TYPE_DATE_TO_DATA_FIELD;
    } else if (fieldType == DataWrapper.DATE_LONG) {
      return Rez.Strings.FIELD_TYPE_LONG_DATE;
    } else if (fieldType == DataWrapper.DATE) {
      return getNativeComplicationLabel(Complications.COMPLICATION_TYPE_DATE);
    } else if (fieldType == DataWrapper.WEEKDAY_MONTHDAY) {
      return getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_WEEKDAY_MONTHDAY
      );
    } else if (fieldType == DataWrapper.TRAINING_STATUS) {
      return getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_TRAINING_STATUS
      );
    } else if (fieldType == DataWrapper.CITY) {
      return Rez.Strings.Rez.Strings.FIELD_TYPE_CITY;
    } else if (fieldType == DataWrapper.SUN_EVENTS) {
      return Rez.Strings.FIELD_TYPE_SUN_EVENTS;
    } else if (fieldType == DataWrapper.HR) {
      return getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_HEART_RATE
      );
    } else if (fieldType == DataWrapper.CALORIES_ACTIVE) {
      return getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_CALORIES
      );
    } else if (fieldType == DataWrapper.STEPS) {
      return getNativeComplicationLabel(Complications.COMPLICATION_TYPE_STEPS);
    } else if (fieldType == DataWrapper.BATTERY) {
      return getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_BATTERY
      );
    } else if (fieldType == DataWrapper.BODY_BATTERY) {
      return getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_BODY_BATTERY
      );
    } else if (fieldType == DataWrapper.RECOVERY_TIME) {
      return getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_RECOVERY_TIME
      );
    } else if (fieldType == DataWrapper.FLOOR) {
      return getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_FLOORS_CLIMBED
      );
    } else if (fieldType == DataWrapper.O2) {
      return getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_PULSE_OX
      );
    } else if (fieldType == DataWrapper.ALTITUDE) {
      return getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_ALTITUDE
      );
    } else if (fieldType == DataWrapper.STRESS) {
      return getNativeComplicationLabel(Complications.COMPLICATION_TYPE_STRESS);
    } else if (fieldType == DataWrapper.WEEKLY_RUN_DISTANCE) {
      return getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_WEEKLY_RUN_DISTANCE
      );
    } else if (fieldType == DataWrapper.WEEKLY_BIKE_DISTANCE) {
      return getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_WEEKLY_BIKE_DISTANCE
      );
    } else if (fieldType == DataWrapper.VO2_RUN) {
      return getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_VO2MAX_RUN
      );
    } else if (fieldType == DataWrapper.VO2_BIKE) {
      return getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_VO2MAX_BIKE
      );
    } else if (fieldType == DataWrapper.RESPIRATION_RATE) {
      return getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_RESPIRATION_RATE
      );
    } else if (fieldType == DataWrapper.SOLAR_INPUT) {
      return getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_SOLAR_INPUT
      );
    } else if (fieldType == DataWrapper.INTENSITY_MINUTES) {
      return getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_INTENSITY_MINUTES
      );
    } else if (fieldType == DataWrapper.CALENDAR_EVENTS) {
      return getNativeComplicationLabel(
        Complications.COMPLICATION_TYPE_CALENDAR_EVENTS
      );
    }
  }

  function getNativeComplicationLabel(compl_type) {
    var res = null;
    var compl_id = new Complications.Id(compl_type);
    if (compl_id instanceof Complications.Id) {
      var compl = null;
      try {
        compl = Complications.getComplication(compl_id);
      } catch (ex) {}
      if (compl != null) {
        res = compl.longLabel;
        if (res == null) {
          res = compl.shortLabel;
        }
      }
    }
    return res;
  }
}
