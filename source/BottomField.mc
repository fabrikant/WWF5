import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;

class BottomField extends SimpleField{

    function initialize(options){
        SimpleField.initialize(options);
    }

    function initializeFont(options){
        font = Graphics.getVectorFont({
            :face => "RobotoCondensedRegular",
            :size => Math.floor(options[:height] * 1.2)
        });
    }

    function draw(colors){
        var dc = getDc();
        dc.setColor(colors[:background], colors[:background]);
        dc.clear();
        dc.setColor(colors[:font], colors[:background]);
        dc.setAntiAlias(true);
        var value = self.method(getId()).invoke();
        dc.drawText(dc.getWidth() / 2, -2, font, value, 
            Graphics.TEXT_JUSTIFY_CENTER );

        // var radius = Math.floor((System.getDeviceSettings().screenHeight - dc.getHeight()) / 2);
        // dc.drawRadialText(
        //     Math.floor(dc.getWidth() / 2), 
        //     Math.floor(dc.getHeight() / 2) - radius, 
        //     font, value, 
        //     Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER, 
        //     270, 
        //     radius, 
        //     Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE);

        drawBorder(dc);
    }
}