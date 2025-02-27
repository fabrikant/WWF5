import Toybox.WatchUi;

class MenuPropertySelecter extends WatchUi.Menu2 {
  var ownerItemWeak;

  function initialize(title, ownerItemWeak) {
    self.ownerItemWeak = ownerItemWeak;
    Menu2.initialize({ :title => title });

    addItem(new ItemPropertySelecter(DataWrapper.EMPTY, ownerItemWeak));
    addItem(new ItemPropertySelecter(DataWrapper.HR, ownerItemWeak));
    addItem(
      new ItemPropertySelecter(DataWrapper.CALORIES_TOTAL, ownerItemWeak)
    );
    addItem(
      new ItemPropertySelecter(DataWrapper.CALORIES_ACTIVE, ownerItemWeak)
    );
    addItem(new ItemPropertySelecter(DataWrapper.STEPS, ownerItemWeak));
    addItem(new ItemPropertySelecter(DataWrapper.DISTANCE, ownerItemWeak));
    addItem(
      new ItemPropertySelecter(DataWrapper.WEEKLY_RUN_DISTANCE, ownerItemWeak)
    );
    addItem(
      new ItemPropertySelecter(DataWrapper.WEEKLY_BIKE_DISTANCE, ownerItemWeak)
    );
    addItem(
      new ItemPropertySelecter(DataWrapper.INTENSITY_MINUTES, ownerItemWeak)
    );
    addItem(new ItemPropertySelecter(DataWrapper.BODY_BATTERY, ownerItemWeak));
    addItem(new ItemPropertySelecter(DataWrapper.RECOVERY_TIME, ownerItemWeak));
    addItem(new ItemPropertySelecter(DataWrapper.STRESS, ownerItemWeak));
    addItem(new ItemPropertySelecter(DataWrapper.O2, ownerItemWeak));
    addItem(new ItemPropertySelecter(DataWrapper.VO2_RUN, ownerItemWeak));
    addItem(new ItemPropertySelecter(DataWrapper.VO2_BIKE, ownerItemWeak));
    addItem(
      new ItemPropertySelecter(DataWrapper.RESPIRATION_RATE, ownerItemWeak)
    );
    addItem(new ItemPropertySelecter(DataWrapper.WEIGHT, ownerItemWeak));
    addItem(new ItemPropertySelecter(DataWrapper.FLOOR, ownerItemWeak));
    addItem(new ItemPropertySelecter(DataWrapper.ALTITUDE, ownerItemWeak));
    addItem(new ItemPropertySelecter(DataWrapper.PRESSURE, ownerItemWeak));
    addItem(new ItemPropertySelecter(DataWrapper.TEMPERATURE, ownerItemWeak));
    addItem(
      new ItemPropertySelecter(DataWrapper.RELATIVE_HUMIDITY, ownerItemWeak)
    );
    addItem(
      new ItemPropertySelecter(DataWrapper.PRECIPITATION_CHANCE, ownerItemWeak)
    );
    addItem(new ItemPropertySelecter(DataWrapper.MOON, ownerItemWeak));
    addItem(new ItemPropertySelecter(DataWrapper.TIME_ZONE, ownerItemWeak));
    addItem(new ItemPropertySelecter(DataWrapper.BATTERY, ownerItemWeak));
    addItem(new ItemPropertySelecter(DataWrapper.SOLAR_INPUT, ownerItemWeak));
    addItem(new ItemPropertySelecter(DataWrapper.DATE_LONG, ownerItemWeak));
    addItem(new ItemPropertySelecter(DataWrapper.DATE, ownerItemWeak));
    addItem(
      new ItemPropertySelecter(DataWrapper.WEEKDAY_MONTHDAY, ownerItemWeak)
    );
    addItem(
      new ItemPropertySelecter(DataWrapper.CALENDAR_EVENTS, ownerItemWeak)
    );
    addItem(
      new ItemPropertySelecter(DataWrapper.TRAINING_STATUS, ownerItemWeak)
    );
    addItem(new ItemPropertySelecter(DataWrapper.CITY, ownerItemWeak));
    addItem(
      new ItemPropertySelecter(
        DataWrapper.FEELS_LIKE_TEMPERATURE,
        ownerItemWeak
      )
    );
    addItem(
      new ItemPropertySelecter(DataWrapper.DATE_TO_DATA_FIELD, ownerItemWeak)
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
