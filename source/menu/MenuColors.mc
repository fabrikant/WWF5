import Toybox.Application;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

//*****************************************************************************
//Пункт меню (аналог класса Item). Но предназначен для указания цвета
//ассоциирован со свойством приложения
//при нажатии открыватеся подменю выбора цветов
class ColorPropertyItem extends WatchUi.IconMenuItem {
  var method_symbol, color;

  function initialize(options) {
    self.method_symbol = options[:method_symbol];
    var label = Application.loadResource(options[:rez_label]);
    color = Application.Properties.getValue(options[:identifier]);
    var icon = new IconDrawable(color);
    IconMenuItem.initialize(
      label,
      colorToString(color),
      options[:identifier],
      icon,
      {}
    );
  }

  function colorToString(color) {
    var res;
    if (color == Graphics.COLOR_TRANSPARENT) {
      res = color.toString();
    } else {
      res = "0x" + color.format("%06X");
    }
    return res;
  }

  function onSelectItem() {
    //Вариант выбора из палитры
    var picker = new ColorPicker(self.weak());
    WatchUi.pushView(
      picker,
      new ColorPickerDelegate(picker.weak()),
      WatchUi.SLIDE_IMMEDIATE
    );

    // //Вариант выбора цвета через подменю с цветами
    // var method = new Lang.Method(Menu, method_symbol);
    // var submenu = method.invoke(self.weak());
    // WatchUi.pushView(
    //   submenu,
    //   new SimpleMenuDelegate(),
    //   WatchUi.SLIDE_IMMEDIATE
    // );
  }

  function onSelectSubmenuItem(newValue) {
    if (newValue instanceof Lang.Number) {
      color = newValue;
    } else {
      color = newValue.toNumber();
    }
    Application.Properties.setValue(getId(), color);
    setSubLabel(colorToString(color));
    setIcon(new IconDrawable(color));
  }
}

//*****************************************************************************
//Вспомогательный объект. Формирет Drawable с цветом для размещения цвета на
//пункте меню
class IconDrawable extends WatchUi.Drawable {
  var color;

  function initialize(color) {
    self.color = color;
    var options = {
      :identifier => color,
      :locX => 0,
      :locY => 0,
      :width => 5,
      :height => 5,
      :visible => true,
    };
    Drawable.initialize(options);
  }

  function draw(dc) {
    if (color == Graphics.COLOR_TRANSPARENT) {
      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
      dc.clear();
      dc.setPenWidth(5);
      dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
      dc.drawLine(0, 0, dc.getWidth(), dc.getHeight());
      dc.drawLine(0, dc.getHeight(), dc.getWidth(), 0);
    } else {
      if (color == Graphics.COLOR_BLACK) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
      } else if (color == Graphics.COLOR_WHITE) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
      } else {
        dc.setColor(Graphics.COLOR_WHITE, color);
      }
      dc.clear();
      dc.drawRectangle(0, 0, dc.getWidth(), dc.getHeight());
    }
  }
}
