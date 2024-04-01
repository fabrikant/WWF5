import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;

class BottomField extends AbstractField{

    var font;

    function initialize(options){
        initializeFont(options);
        AbstractField.initialize(options);
    }

    function initializeFont(options){
        font = Graphics.getVectorFont({
            :face => vectorFontName(),
            :size => Math.floor(options[:height] * 1.2)
        });
    }

    function draw(colors){
        AbstractField.draw(colors);
        var dc = getDc();
        dc.setColor(colors[:font], colors[:background]);
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