import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Time;

class AbstractField extends WatchUi.Layer{

     function initialize(options){
        Layer.initialize(options);
    }

    function draw(colors){
        var dc = getDc();
        dc.setColor(colors[:background], colors[:background]);
        dc.clear();
        dc.setAntiAlias(true);
    }

    function drawBorder(dc){
        //return;
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_GREEN);
        dc.drawRectangle(0, 0, dc.getWidth(), dc.getHeight());
    }

    function clock(){
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

    function convertValueTemperature(сelsius){
      var value;
      if (сelsius != null){
        if (System.getDeviceSettings().temperatureUnits == System.UNIT_STATUTE){ /*F*/
          value = ((сelsius*9/5) + 32);
        }else{
          value = сelsius;
        }
      }else{
        value = "";
      }	
      return value.format("%d")+"°";        
    }

    function converValueWindSpeed(wind_speed){
      return Math.round(wind_speed).format("%d")+"m/s";
    }
}