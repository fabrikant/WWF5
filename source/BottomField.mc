import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;

class BottomField extends AbstractField {
  var font;

  function initialize(options) {
    initializeFont(options);
    AbstractField.initialize(options);
  }

  function initializeFont(options) {
    font = Graphics.getVectorFont({
      :face => vectorFontName(),
      :size => Math.floor(options[:height] * 1.2),
    });
  }

  function draw(colors) {
    AbstractField.draw(colors);
    var dc = getDc();
    dc.setColor(colors[:font], colors[:background]);
    var data = DataWrapper.getData(Application.Properties.getValue(getId()));
    compl_id = data[:compl_id];
    
    if (data[:value] != null) {
      dc.drawText(
        dc.getWidth() / 2,
        -2,
        font,
        data[:value],
        Graphics.TEXT_JUSTIFY_CENTER
      );
    }

    drawBorder(dc);
  }
}
