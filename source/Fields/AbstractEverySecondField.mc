class AbstractEverySecondField extends AbstractField {
  function initialize(options) {
    AbstractField.initialize(options);
  }

  function drawText(dc, colors, x, y, font, text, justification) {
    var color = colors[:font];
    var color_empty = colors[:font_empty_segments];

    if (
      color_empty != Graphics.COLOR_TRANSPARENT &&
      color_empty != colors[:background] &&
      color_empty != color
    ) {
      var empty_text = "888888".substring(0, text.length());
      dc.setColor(color_empty, colors[:background]);
      dc.drawText(x, y, font, empty_text, justification);
    }

    if (
      color_empty == colors[:background] or
      color_empty == Graphics.COLOR_TRANSPARENT
    ) {
      dc.setColor(color, colors[:background]);
    } else {
      dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    }

    dc.drawText(x, y, font, text, justification);
  }
}
