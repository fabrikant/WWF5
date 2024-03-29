import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Complications;
import Toybox.Time;
import Toybox.Math;

class WeatherWidget extends SimpleField{

    function initialize(options){
        SimpleField.initialize(options);
    }
    
    function initializeFont(options){
    }

    function draw(colors){
        
        var dc = getDc();
        dc.setColor(colors[:background], colors[:background]);
        dc.clear();
        dc.setAntiAlias(true);

        
        
        drawBorder(dc);
    }
}