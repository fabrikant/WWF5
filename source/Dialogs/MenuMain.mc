import Toybox.WatchUi;

class MenuMain extends WatchUi.Menu2 {
  function initialize() {
    Menu2.initialize({ :title => Rez.Strings.MenuHeader });

    addItem(new ItemPresets());
    addItem(new ItemSubMenuColors());
    addItem(new ItemPropertyDataField("data_scale", Rez.Strings.DataScale));
    addItem(new ItemPropertyDataField("data_small", Rez.Strings.SmallField));
    addItem(new ItemPropertyDataFieldSunEvents("data_sun", Rez.Strings.DataSun));
    addItem(new ItemPropertyDataField("data_1", Rez.Strings.Data1));
    addItem(new ItemPropertyDataField("data_2", Rez.Strings.Data2));
    addItem(new ItemPropertyDataField("data_3", Rez.Strings.Data3));
    addItem(new ItemPropertyDataField("data_bottom", Rez.Strings.BottomField));
    addItem(new ItemPropertyBluetoothConnection());
    addItem(new ItemPropertyTogle("show_DND", Rez.Strings.show_DND));
    addItem(new ItemPropertyWindSpeed());
    addItem(new ItemPropertyPressure());
    addItem(new ItemPropertyText("T1TZ", Rez.Strings.T1TZ));
    addItem(new ItemPropertyTogle("show_w_source", Rez.Strings.show_w_source));
    addItem(new ItemPropertyText("owm_key", Rez.Strings.owm_key));
  }
}
