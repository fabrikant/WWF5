import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Time;

class SimpleField extends WatchUi.Layer{

    var font;

    function initialize(options){
        initializeFont(options);
        Layer.initialize(options);
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
        
        var dc = getDc();
        dc.setColor(colors[:background], colors[:background]);
        dc.clear();
        dc.setAntiAlias(true);

        var value = self.method(getId()).invoke();
        font.writeString(dc, 0, 0, value, Graphics.TEXT_JUSTIFY_LEFT);

        drawBorder(dc);
    }

    function drawBorder(dc){
        //return;
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_GREEN);
        dc.drawRectangle(0, 0, dc.getWidth(), dc.getHeight());
    }

    function hoursMinutesNow(){
        return hours_minutes(System.getClockTime());
    }

    function hours_minutes(clock){
        var hours = clock.hour;
        if (!System.getDeviceSettings().is24Hour) {
        	if (hours > 12) {
                hours = hours - 12;
            }
        }
		return Lang.format("$1$:$2$", [hours.format("%02d"), clock.min.format("%02d")]);
    }

    function hours(){
        var hours = System.getClockTime().hour;
        if (!System.getDeviceSettings().is24Hour) {
        	if (hours > 12) {
                hours = hours - 12;
            }
        }
		return hours.format("%02d");
    }

    function minutes(){
		return System.getClockTime().min.format("%02d");
    }
    
    function seconds(){
		return System.getClockTime().sec.format("%02d");
    }

    function date(){
        var now = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
		return Lang.format("$1$, $2$ $3$", [now.day_of_week, now.day, now.month]);
    }

    function createImage(resource, colors){
		var _bitmap = Application.loadResource(resource);
		if ( Graphics has :createBufferedBitmap){
			var _bufferedBitmapRef = Graphics.createBufferedBitmap({
				:bitmapResource => _bitmap,
				:width => _bitmap.getWidth(),
				:height => _bitmap.getHeight()
			});
			var _bufferedBitmap = _bufferedBitmapRef.get(); 
			_bufferedBitmap.setPalette([colors[:font], Graphics.COLOR_TRANSPARENT]);
			return _bufferedBitmap;
		}else{
			var _bufferedBitmap = new Graphics.BufferedBitmap({
				:bitmapResource => _bitmap,
				:width => _bitmap.getWidth(),
				:height => _bitmap.getHeight()
			});
			_bufferedBitmap.setPalette([colors[:font], Graphics.COLOR_TRANSPARENT]);
			return _bufferedBitmap;
		}
	}
}