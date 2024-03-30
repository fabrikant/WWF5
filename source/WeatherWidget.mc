import Toybox.Graphics;
import Toybox.System;
import Toybox.Weather;
import Toybox.Application;
import Toybox.Math;

class WeatherWidget extends AbstractField{

    var font_temp, font_wind;

    function initialize(options){
        initializeFont(options);
        AbstractField.initialize(options);
    }
    
    function initializeFont(options){
        var fonts = getApp().watch_view.fonts;
        var font_height = Math.floor(options[:height] * 0.45);
        var ratio = fonts[:sun_events].getRatio();
        font_temp = new FontLessFont({
            :width => Math.floor(font_height * ratio),
            :height => font_height,
            :line_width => 3,
            :line_offset => 1,
            :simple_style => false,
        });
        font_wind = fonts[:sun_events];
    }

    function draw(colors){
        AbstractField.draw(colors);
        var weather = Weather.getCurrentConditions();
        if (weather == null){
            drawBorder(getDc());
            return;
        }
        var dc = getDc();

        //Иконка погоды        
        var bitmap = createImage(getGarminConditionRez(weather.condition), colors);
        var temp_x = dc.getWidth() * 0.08;
        dc.drawBitmap(temp_x, 
            (dc.getHeight() - bitmap.getHeight()) / 2, 
            bitmap);
        
        temp_x += bitmap.getWidth();
        var temperature = convertValueTemperature(weather.temperature);
        font_temp.writeString(dc, temp_x, Math.floor(dc.getHeight()/2),
            temperature,
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        
        drawBorder(dc);
        
    }


    function getGarminConditionRez(condition){
        if (condition == Weather.CONDITION_CLEAR){
            return Rez.Drawables.CONDITION_CLEAR;
        }else if(condition == Weather.CONDITION_PARTLY_CLOUDY){
            return Rez.Drawables.CONDITION_PARTLY_CLOUDY;
        }else if(condition == Weather.CONDITION_MOSTLY_CLOUDY){
            return Rez.Drawables.CONDITION_MOSTLY_CLOUDY;
        }else if(condition == Weather.CONDITION_RAIN){
            return Rez.Drawables.CONDITION_RAIN;
        }else if(condition == Weather.CONDITION_SNOW){
            return Rez.Drawables.CONDITION_SNOW;
        }else if(condition == Weather.CONDITION_WINDY){
            return Rez.Drawables.CONDITION_WINDY;
        }else if(condition == Weather.CONDITION_THUNDERSTORMS){
            return Rez.Drawables.CONDITION_THUNDERSTORMS;
        }else if(condition == Weather.CONDITION_WINTRY_MIX){
            return Rez.Drawables.CONDITION_WINTRY_MIX;
        }else if(condition == Weather.CONDITION_FOG){
            return Rez.Drawables.CONDITION_FOG;
        }else if(condition == Weather.CONDITION_HAZY){
            return Rez.Drawables.CONDITION_HAZY;
        }else if(condition == Weather.CONDITION_HAIL){
            return Rez.Drawables.CONDITION_HAIL;
        }else if(condition == Weather.CONDITION_SCATTERED_SHOWERS){
            return Rez.Drawables.CONDITION_SCATTERED_SHOWERS;
        }else if(condition == Weather.CONDITION_SCATTERED_THUNDERSTORMS){
            return Rez.Drawables.CONDITION_SCATTERED_THUNDERSTORMS;
        }else if(condition == Weather.CONDITION_UNKNOWN_PRECIPITATION){
            return Rez.Drawables.CONDITION_UNKNOWN_PRECIPITATION;
        }else if(condition == Weather.CONDITION_LIGHT_RAIN){
            return Rez.Drawables.CONDITION_LIGHT_RAIN;
        }else if(condition == Weather.CONDITION_HEAVY_RAIN){
            return Rez.Drawables.CONDITION_HEAVY_RAIN;
        }else if(condition == Weather.CONDITION_LIGHT_SNOW){
            return Rez.Drawables.CONDITION_LIGHT_SNOW;
        }else if(condition == Weather.CONDITION_HEAVY_SNOW){
            return Rez.Drawables.CONDITION_HEAVY_SNOW;
        }else if(condition == Weather.CONDITION_LIGHT_RAIN_SNOW){
            return Rez.Drawables.CONDITION_LIGHT_RAIN_SNOW;
        }else if(condition == Weather.CONDITION_HEAVY_RAIN_SNOW){
            return Rez.Drawables.CONDITION_HEAVY_RAIN_SNOW;
        }else if(condition == Weather.CONDITION_CLOUDY){
            return Rez.Drawables.CONDITION_CLOUDY;
        }else if(condition == Weather.CONDITION_RAIN_SNOW){
            return Rez.Drawables.CONDITION_RAIN_SNOW;
        }else if(condition == Weather.CONDITION_PARTLY_CLEAR){
            return Rez.Drawables.CONDITION_PARTLY_CLEAR;
        }else if(condition == Weather.CONDITION_MOSTLY_CLEAR){
            return Rez.Drawables.CONDITION_MOSTLY_CLEAR;
        }else if(condition == Weather.CONDITION_LIGHT_SHOWERS){
            return Rez.Drawables.CONDITION_LIGHT_SHOWERS;
        }else if(condition == Weather.CONDITION_SHOWERS){
            return Rez.Drawables.CONDITION_SHOWERS;
        }else if(condition == Weather.CONDITION_HEAVY_SHOWERS){
            return Rez.Drawables.CONDITION_HEAVY_SHOWERS;
        }else if(condition == Weather.CONDITION_CHANCE_OF_SHOWERS){
            return Rez.Drawables.CONDITION_CHANCE_OF_SHOWERS;
        }else if(condition == Weather.CONDITION_CHANCE_OF_THUNDERSTORMS){
            return Rez.Drawables.CONDITION_CHANCE_OF_THUNDERSTORMS;
        }else if(condition == Weather.CONDITION_MIST){
            return Rez.Drawables.CONDITION_MIST;
        }else if(condition == Weather.CONDITION_DUST){
            return Rez.Drawables.CONDITION_DUST;
        }else if(condition == Weather.CONDITION_DRIZZLE){
            return Rez.Drawables.CONDITION_DRIZZLE;
        }else if(condition == Weather.CONDITION_TORNADO){
            return Rez.Drawables.CONDITION_TORNADO;
        }else if(condition == Weather.CONDITION_SMOKE){
            return Rez.Drawables.CONDITION_SMOKE;
        }else if(condition == Weather.CONDITION_ICE){
            return Rez.Drawables.CONDITION_ICE;
        }else if(condition == Weather.CONDITION_SAND){
            return Rez.Drawables.CONDITION_SAND;
        }else if(condition == Weather.CONDITION_SQUALL){
            return Rez.Drawables.CONDITION_SQUALL;
        }else if(condition == Weather.CONDITION_SANDSTORM){
            return Rez.Drawables.CONDITION_SANDSTORM;
        }else if(condition == Weather.CONDITION_VOLCANIC_ASH){
            return Rez.Drawables.CONDITION_VOLCANIC_ASH;
        }else if(condition == Weather.CONDITION_HAZE){
            return Rez.Drawables.CONDITION_HAZE;
        }else if(condition == Weather.CONDITION_FAIR){
            return Rez.Drawables.CONDITION_FAIR;
        }else if(condition == Weather.CONDITION_HURRICANE){
            return Rez.Drawables.CONDITION_HURRICANE;
        }else if(condition == Weather.CONDITION_TROPICAL_STORM){
            return Rez.Drawables.CONDITION_TROPICAL_STORM;
        }else if(condition == Weather.CONDITION_CHANCE_OF_SNOW){
            return Rez.Drawables.CONDITION_CHANCE_OF_SNOW;
        }else if(condition == Weather.CONDITION_CHANCE_OF_RAIN_SNOW){
            return Rez.Drawables.CONDITION_CHANCE_OF_RAIN_SNOW;
        }else if(condition == Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN){
            return Rez.Drawables.CONDITION_CLOUDY_CHANCE_OF_RAIN;
        }else if(condition == Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW){
            return Rez.Drawables.CONDITION_CLOUDY_CHANCE_OF_SNOW;
        }else if(condition == Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW){
            return Rez.Drawables.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW;
        }else if(condition == Weather.CONDITION_FLURRIES){
            return Rez.Drawables.CONDITION_FLURRIES;
        }else if(condition == Weather.CONDITION_FREEZING_RAIN){
            return Rez.Drawables.CONDITION_FREEZING_RAIN;
        }else if(condition == Weather.CONDITION_SLEET){
            return Rez.Drawables.CONDITION_SLEET;
        }else if(condition == Weather.CONDITION_ICE_SNOW){
            return Rez.Drawables.CONDITION_ICE_SNOW;
        }else if(condition == Weather.CONDITION_THIN_CLOUDS){
            return Rez.Drawables.CONDITION_THIN_CLOUDS;
        }else if(condition == Weather.CONDITION_UNKNOWN){
            return Rez.Drawables.CONDITION_UNKNOWN;
        }
    }
}