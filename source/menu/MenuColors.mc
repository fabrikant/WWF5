import Toybox.Application;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

//*****************************************************************************
//Подменю выбора конкретного цвета
class ColorSelectMenu extends WatchUi.Menu2 {
  function initialize(options) {
    Menu2.initialize({ :title => Application.loadResource(options[:title]) });
    var current_color = null;
    if (options[:parent_item_week].stillAlive()) {
      current_color = options[:parent_item_week].get().color;
    }
    for (var i = 0; i < options[:items].size(); i++) {
      var item_prop = options[:items][i];
      addItem(new ColorSelectItem(item_prop));
      if (item_prop[:color] == current_color) {
        setFocus(i);
      }
    }
  }
}

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
    //Вариант выбора цвета через подменю с цветами
    var method = new Lang.Method(Menu, method_symbol);
    var submenu = method.invoke(self.weak());
    WatchUi.pushView(
      submenu,
      new SimpleMenuDelegate(),
      WatchUi.SLIDE_IMMEDIATE
    );
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
//Пункт меню выбора конкретного цвета
//при нажатии значение возвращается в родительский пункт меню
class ColorSelectItem extends ColorPropertyItem {
  var parent_item_week;

  function initialize(options) {
    color = options[:color];
    var label = colorToString(options[:color]);
    var icon = new IconDrawable(color);
    self.parent_item_week = options[:parent_item_week];
    IconMenuItem.initialize(label, null, options[:identifier], icon, {});
  }

  function onSelectItem() {
    if (parent_item_week.stillAlive()) {
      var obj = parent_item_week.get();
      if (obj != null) {
        obj.onSelectSubmenuItem(getId().toNumber());
      }
    }
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
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
