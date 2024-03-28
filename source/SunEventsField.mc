import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;


class SunEventsField extends SimpleField{

    function initialize(options){
        SimpleField.initialize(options);
    }

    function initializeFont(options){
        var font_w = Math.floor(options[:width] / options[:max_lenght]);
        //var line_w = Math.floor(font_w / 4.2);
        //var font_w = 10;
        var line_w = 2;

        font = new FontLessFont({
            :width => font_w,
            :height => options[:height],
            :line_width => line_w,
            :line_offset => 2,
            :simple_style => true,
        });
    }
    function draw(colors){
        
        var dc = getDc();
        dc.setColor(colors[:background], colors[:background]);
        dc.clear();
        dc.setAntiAlias(true);

        // var value = self.method(getId()).invoke();
        var value = "07:45::19:30";
        font.writeString(dc, dc.getWidth()/2, dc.getHeight()/2, value, colors, 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        drawBorder(dc);
    }}