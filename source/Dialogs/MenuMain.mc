import Toybox.WatchUi;

class MenuMain extends WatchUi.Menu2 {
  function initialize() {
    Presets.generatePresetsStorage();

    Menu2.initialize({ :title => Rez.Strings.MenuHeader });

    addItem(new ItemPresets());
    addItem(new ItemSubMenuColors());
    addItem(new ItemPropertyDataField("data_scale", Rez.Strings.DataScale));
    
    addItem(
      new ItemPropertyTogle(
        "show_weather_data",
        Rez.Strings.show_w_data,
        Rez.Strings.show_w_data_true,
        Rez.Strings.show_w_data_false
      )
    );
    addItem(new ItemPropertyDataField("data_weather", Rez.Strings.DataWeater));
    
    addItem(
      new ItemPropertyDataFieldSunEvents(
        "data_sun",
        Rez.Strings.FIELD_TYPE_SUN_EVENTS
      )
    );
    addItem(new ItemPropertyDataField("data_small", Rez.Strings.SmallField));
    addItem(new ItemPropertyDataField("data_1", Rez.Strings.Data1));
    addItem(new ItemPropertyDataField("data_2", Rez.Strings.Data2));
    addItem(new ItemPropertyDataField("data_3", Rez.Strings.Data3));
    addItem(new ItemPropertyDataField("data_bottom", Rez.Strings.BottomField));
    addItem(new ItemPropertyBluetoothConnection());
    addItem(
      new ItemPropertyTogle("show_DND", Rez.Strings.show_DND, null, null)
    );
    addItem(new ItemPropertyWindSpeed());
    addItem(new ItemPropertyPressure());
    addItem(new ItemPropertyText("T1TZ", Rez.Strings.T1TZ));
    addItem(
      new ItemPropertyTogle(
        "show_w_source",
        Rez.Strings.show_w_source,
        null,
        null
      )
    );
    addItem(new ItemPropertyText("owm_key", Rez.Strings.owm_key));
  }
}
