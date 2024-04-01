import Toybox.Graphics;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Complications;
import Toybox.Lang;

class ScaleWidget extends AbstractField{

    function initialize(options){
        AbstractField.initialize(options);
    }

    function draw(colors){
        AbstractField.draw(colors);
        var dc = getDc();
        var compl_type = getApp().system_complications[Complications.COMPLICATION_TYPE_BATTERY];
        var compl = Complications.getComplication(compl_type);

        if (compl != null){
            drawScale(dc, colors, compl, scaleWidth());
        }
        drawBorder(dc);
    }

    function drawScale(dc, colors, compl, scale_width){

        var system_radius = System.getDeviceSettings().screenHeight / 2;
        var scale_radius = system_radius - scale_width / 2;
        var pattern = getApp().watch_view.pattern;
        var offset_fegree = 5;
        var sin_angle = (system_radius - pattern.reference_points[:y][2]).toFloat() / system_radius;
        var angle_min = 180f - Math.toDegrees(Math.asin(sin_angle)) - offset_fegree;
        sin_angle = (system_radius - pattern.reference_points[:y][1]).toFloat() / system_radius;
        var angle_max = 180f - Math.toDegrees(Math.asin(sin_angle)) + offset_fegree;
        var center_x = dc.getWidth() + Global.mod(getX() + dc.getWidth() - system_radius);
        var center_y = dc.getHeight() + Global.mod(getY() + dc.getHeight() - system_radius);
        
        dc.setPenWidth(scale_width);
        dc.setColor(colors[:font], colors[:font]);

        dc.drawArc(center_x, center_y, scale_radius, 
            Graphics.ARC_CLOCKWISE, angle_min, angle_max);

        scale_width -= 2;
        angle_min -= 1;
        angle_max += 1;

        dc.setPenWidth(scale_width);
        dc.setColor(colors[:background], colors[:background]);
        dc.drawArc(center_x, center_y, scale_radius, 
            Graphics.ARC_CLOCKWISE, angle_min, angle_max);

        var angle_value = angle_min - compl.value * Global.mod(angle_min - angle_max) / 100;

        var scale_color = Graphics.COLOR_GREEN;
        if (compl.value <= 20){
            scale_color = Graphics.COLOR_RED;
        }

        dc.setColor(scale_color, scale_color);    
        dc.drawArc(center_x, center_y, scale_radius, 
            Graphics.ARC_CLOCKWISE, angle_min, angle_value);

        //Подпись
        dc.setColor(colors[:font], colors[:font]);
        //var font_height = getApp().watch_view.fonts[:sun_events].getHeight();
        var font_height = Math.round(System.getDeviceSettings().screenHeight * 0.105).toNumber();
        var font = Graphics.getVectorFont({
            :face => vectorFontName(),
            :size => font_height,
        });
        
        var str = Lang.format("$1$$2$", [compl.value.format("%d"), compl.unit]);
        var str_angle = angle_min - Global.mod(angle_min - angle_max) / 2;
        dc.drawRadialText(center_x, center_y, font, str, 
            Graphics.TEXT_JUSTIFY_CENTER, 
            str_angle, 
            system_radius - scale_width - font_height, 
            Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE);

    }
}