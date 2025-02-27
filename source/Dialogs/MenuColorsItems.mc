import Toybox.WatchUi;

class MenuColorsItems extends WatchUi.Menu2 {
  function initialize() {
    Menu2.initialize({ :title => Rez.Strings.SubmenuColors });
    addItem(new ItemPropertyColor("c_image", Rez.Strings.color_font_image));
    addItem(new ItemPropertyColor("c_font", Rez.Strings.c_font));
    addItem(new ItemPropertyColor("c_es", Rez.Strings.c_es));
    addItem(new ItemPropertyColor("c_bgnd", Rez.Strings.c_bgnd));
    addItem(new ItemPropertyColor("c_patt", Rez.Strings.c_patt));
    addItem(new ItemPropertyColor("c_patt_d", Rez.Strings.c_patt_d));
    addItem(new ItemPropertyColor("c_scale", Rez.Strings.c_scale));
  }
}
