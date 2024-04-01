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
    //dc.setColor(colors[:background], colors[:background]);
    dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
    dc.clear();
    dc.setAntiAlias(true);
  }

  function drawBorder(dc){
    //return;
    dc.setPenWidth(1);
    dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_GREEN);
    dc.drawRectangle(0, 0, dc.getWidth(), dc.getHeight());
  }

  function scaleWidth(){
    return Math.round(System.getDeviceSettings().screenHeight * 0.04).toNumber();
  }

  function vectorFontName(){
    return "RobotoCondensedRegular";
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
    
    var value = wind_speed;//meters/sec
    var unit_str = "";
    var unit =  Application.Properties.getValue("wind_speed_unit");
    if (unit == Global.UNIT_SPEED_MS) {
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitMSec);
    }else if (unit == Global.UNIT_SPEED_KMH){ /*km/h*/
      value = wind_speed*3.6;
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitKmH);
    }else if (unit == Global.UNIT_SPEED_MLH){ /*mile/h*/
      value = wind_speed*2.237;
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitMileH);
    }else if (unit == Global.UNIT_SPEED_FTS){ /*ft/s*/
      value = wind_speed*3.281;
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitFtSec);
    }else if (unit == Global.UNIT_SPEED_BEAUF){ /*Beaufort*/
      value = getBeaufort(wind_speed);
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitBeauf);
    }else if (unit == Global.UNIT_SPEED_KNOTS){ /*knots*/
      value = wind_speed*1.94384;
      unit_str = Application.loadResource(Rez.Strings.SpeedUnitKnots);
    }
    return value.format("%d")+" "+unit_str;      
  }

	function getBeaufort(wind_speed){
		if(wind_speed >= 33){
			return 12;
		}else if(wind_speed >= 28.5){
			return 11;
		}else if(wind_speed >= 24.5){
			return 10;
		}else if(wind_speed >= 20.8){
			return 9;
		}else if(wind_speed >= 17.2){
			return 8;
		}else if(wind_speed >= 13.9){
			return 7;
		}else if(wind_speed >= 10.8){
			return 6;
		}else if(wind_speed >= 8){
			return 5;
		}else if(wind_speed >= 5.5){
			return 4;
		}else if(wind_speed >= 3.4){
			return 3;
		}else if(wind_speed >= 1.6){
			return 2;
		}else if(wind_speed >= 0.3){
			return 1;
		}else {
			return 0;
		}
	}
}