import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Complications;
import Toybox.Time;
import Toybox.Math;

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

        var sunrise = getSunEventTime(getApp().system_complications[Complications.COMPLICATION_TYPE_SUNRISE]);
        var sunset = getSunEventTime(getApp().system_complications[Complications.COMPLICATION_TYPE_SUNSET]);
        var image = createImage(Rez.Drawables.sunEvent, colors);

        var image_x = Math.floor((dc.getWidth() - image.getWidth()) / 2);
        //var image_y = Math.floor((dc.getHeight() - image.getHeight()) / 2);

        dc.drawBitmap(image_x, 0, image);

        font.writeString(dc, image_x - 1, dc.getHeight()/2, sunrise, colors, 
             Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);

        font.writeString(dc, image_x + image.getWidth() + 1, dc.getHeight()/2, sunset, colors, 
             Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);     
        
        
        System.println("image_x "+image_x);
        System.println(image.getWidth());
        //var value = sunrise+"::"+sunset;
        // font.writeString(dc, dc.getWidth()/2, dc.getHeight()/2, value, colors, 
        //     Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        drawBorder(dc);
    }

    function getSunEventTime(compl_type){
        var res = "";
        var compl = Complications.getComplication(compl_type);
        if (compl.value != null){
            var moment = Time.today().add(new Time.Duration(compl.value));
            res = hours_minutes(Time.Gregorian.info(moment, Time.FORMAT_SHORT)); 
        }
        return res;
    }
}