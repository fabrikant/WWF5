import Toybox.WatchUi;

class MenuListSelector extends WatchUi.Menu2 {
  function initialize(title, ownerItemWeak, values) {
    Menu2.initialize({ :title => title });

    var keys = values.keys();
    for (var i = 0; i < keys.size(); i++) {
      addItem(new ItemListSelector(keys[i], values[keys[i]], ownerItemWeak));
    }
  }
}
