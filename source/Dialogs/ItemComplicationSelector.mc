import Toybox.WatchUi;
import Toybox.Complications;

class ItemComplicationSelector extends WatchUi.IconMenuItem {
  var ownerItemWeak = null;

  function initialize(complication, ownerItemWeak) {
    self.ownerItemWeak = ownerItemWeak;

    var label = complication.longLabel;
    if (label == null) {
      label = complication.shortLabel;
    }
    if (label == null) {
      label = "<<Unknown id:" + complication.complicationId + ">>";
    }

    var drawable = new ItemComplicationSelectorDrawable(complication.getIcon());
    IconMenuItem.initialize(
      label,
      null,
      complication.complicationId,
      drawable,
      {}
    );
  }

  function onSelectItem() {
    if (ownerItemWeak.stillAlive()) {
      var owner = ownerItemWeak.get();
      owner.updateValue(getId());
      WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
  }
}

class ItemComplicationSelectorDrawable extends WatchUi.Drawable {
  var complIcon = null;
  var firstDraw = null;
  var complIconH, complIconW;
  var complIconX, complIconY;

  function initialize(complIcon) {
    self.complIcon = complIcon;
    var options = {
      :identifier => null,
      :locX => 0,
      :locY => 0,
      :width => 5,
      :height => 5,
      :visible => true,
    };
    firstDraw = true;
    Drawable.initialize(options);
  }

  function draw(dc) {
    if (complIcon == null) {
      return;
    }
    if (firstDraw) {
      firstDraw = false;
      setSize(dc.getWidth(), dc.getHeight());

      if (complIcon.getHeight() == 0 or complIcon.getWidth() == 0) {
        complIcon = null;
        return;
      }

      var iconMaxSize = complIcon.getHeight();
      if (complIcon.getWidth() > iconMaxSize) {
        iconMaxSize = complIcon.getWidth();
      }

      var dcMinSize = dc.getHeight();
      if (dcMinSize > dc.getWidth()) {
        dcMinSize = dc.getWidth();
      }
      dcMinSize -= 8;
      var k = dcMinSize.toDouble() / iconMaxSize;

      complIconW = (complIcon.getWidth() * k).toNumber();
      complIconH = (complIcon.getHeight() * k).toNumber();

      complIconX = (dc.getWidth() - complIconW) / 2;
      complIconY = (dc.getHeight() - complIconH) / 2;
    }
    dc.drawScaledBitmap(
      complIconX,
      complIconY,
      complIconW,
      complIconH,
      complIcon
    );
  }
}
