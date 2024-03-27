import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;

class SimpleField extends WatchUi.Layer{

    var font;

    function initialize(options){

        font = new FontLessFont({
            :width => Math.floor(options[:width] / options[:max_lenght]),
            :height => options[:height],
            :line_width => 6,
            :line_offset => 1,
        });

        Layer.initialize(options);
    }

    function draw(colors){
        
        var dc = getDc();
        font.writeString(dc, 0, 0, "55", colors, Graphics.TEXT_JUSTIFY_LEFT);

        drawBorder(dc);
    }

    function drawBorder(dc){
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_GREEN);
        dc.drawRectangle(0, 0, dc.getWidth(), dc.getHeight());
    }
}