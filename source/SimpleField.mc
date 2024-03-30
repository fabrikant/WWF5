import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Time;

class SimpleField extends AbstractField{

    var font;

    function initialize(options){
        initializeFont(options);
        AbstractField.initialize(options);
    }

    function initializeFont(options){
        var font_w = Math.floor(options[:width] / options[:max_lenght]);
        var line_w = Math.floor(font_w / 4.2);
        font = new FontLessFont({
            :width => font_w,
            :height => options[:height],
            :line_width => line_w,
            :line_offset => 2,
        });
    }

    function draw(colors){
        AbstractField.draw(colors);
        var dc = getDc();
        var value = self.method(getId()).invoke();
        font.writeString(dc, 0, 0, value, Graphics.TEXT_JUSTIFY_LEFT);
        drawBorder(dc);
    }

}