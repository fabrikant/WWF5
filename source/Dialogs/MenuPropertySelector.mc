import Toybox.WatchUi;

class MenuPropertySelector extends WatchUi.Menu2 {
  var ownerItemWeak;

  function initialize(title, ownerItemWeak) {
    self.ownerItemWeak = ownerItemWeak;
    Menu2.initialize({ :title => title });

    addItem(new ItemPropertySelector(DataWrapper.EMPTY, ownerItemWeak));
    addItem(new ItemPropertySelector(DataWrapper.HR, ownerItemWeak));
    addItem(
      new ItemPropertySelector(DataWrapper.CALORIES_TOTAL, ownerItemWeak)
    );
    addItem(
      new ItemPropertySelector(DataWrapper.CALORIES_ACTIVE, ownerItemWeak)
    );
    addItem(new ItemPropertySelector(DataWrapper.STEPS, ownerItemWeak));
    addItem(new ItemPropertySelector(DataWrapper.DISTANCE, ownerItemWeak));
    addItem(
      new ItemPropertySelector(DataWrapper.WEEKLY_RUN_DISTANCE, ownerItemWeak)
    );
    addItem(
      new ItemPropertySelector(DataWrapper.WEEKLY_BIKE_DISTANCE, ownerItemWeak)
    );
    addItem(
      new ItemPropertySelector(DataWrapper.INTENSITY_MINUTES, ownerItemWeak)
    );
    addItem(new ItemPropertySelector(DataWrapper.BODY_BATTERY, ownerItemWeak));
    addItem(new ItemPropertySelector(DataWrapper.RECOVERY_TIME, ownerItemWeak));
    addItem(new ItemPropertySelector(DataWrapper.STRESS, ownerItemWeak));
    addItem(new ItemPropertySelector(DataWrapper.O2, ownerItemWeak));
    addItem(new ItemPropertySelector(DataWrapper.VO2_RUN, ownerItemWeak));
    addItem(new ItemPropertySelector(DataWrapper.VO2_BIKE, ownerItemWeak));
    addItem(
      new ItemPropertySelector(DataWrapper.RESPIRATION_RATE, ownerItemWeak)
    );
    addItem(new ItemPropertySelector(DataWrapper.WEIGHT, ownerItemWeak));
    addItem(new ItemPropertySelector(DataWrapper.FLOOR, ownerItemWeak));
    addItem(new ItemPropertySelector(DataWrapper.ALTITUDE, ownerItemWeak));
    addItem(new ItemPropertySelector(DataWrapper.PRESSURE, ownerItemWeak));
    addItem(new ItemPropertySelector(DataWrapper.TEMPERATURE, ownerItemWeak));
    addItem(
      new ItemPropertySelector(DataWrapper.RELATIVE_HUMIDITY, ownerItemWeak)
    );
    addItem(
      new ItemPropertySelector(DataWrapper.PRECIPITATION_CHANCE, ownerItemWeak)
    );
    addItem(new ItemPropertySelector(DataWrapper.MOON, ownerItemWeak));
    addItem(new ItemPropertySelector(DataWrapper.TIME_ZONE, ownerItemWeak));
    addItem(new ItemPropertySelector(DataWrapper.BATTERY, ownerItemWeak));
    addItem(new ItemPropertySelector(DataWrapper.SOLAR_INPUT, ownerItemWeak));
    addItem(
      new ItemPropertySelector(DataWrapper.DATE_TO_DATA_FIELD, ownerItemWeak)
    );
    addItem(new ItemPropertySelector(DataWrapper.DATE, ownerItemWeak));
    addItem(
      new ItemPropertySelector(DataWrapper.WEEKDAY_MONTHDAY, ownerItemWeak)
    );
    addItem(
      new ItemPropertySelector(DataWrapper.CALENDAR_EVENTS, ownerItemWeak)
    );
    addItem(
      new ItemPropertySelector(DataWrapper.TRAINING_STATUS, ownerItemWeak)
    );
    addItem(new ItemPropertySelector(DataWrapper.CITY, ownerItemWeak));
    addItem(
      new ItemPropertySelector(
        DataWrapper.FEELS_LIKE_TEMPERATURE,
        ownerItemWeak
      )
    );

    if (ownerItemWeak.stillAlive()) {
      var owner = ownerItemWeak.get();
      var index = findItemById(owner.fieldType);
      if (index >= 0) {
        setFocus(index);
      }
    }
  }
}
