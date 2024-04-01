import Toybox.Graphics;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Complications;
import Toybox.Lang;

class DataField extends AbstractField{

    var label_x, label_y, label_radius, label_angle, font_label;

    function initialize(options){
        AbstractField.initialize(options);
        var font_height = Math.round(System.getDeviceSettings().screenHeight * 0.07).toNumber();
        font_label = Graphics.getVectorFont({
                :face => vectorFontName(),
                :size => font_height,
            }); 
        if (getId().equals("data_type_1")){
            calculateLabelCoord1();
        }if (getId().equals("data_type_3")){
            calculateLabelCoord3();
        }
    }

    function draw(colors){
        AbstractField.draw(colors);
        var dc = getDc();
        var compl = getFieldComplication();

        if (compl != null){
            var font_value = getApp().watch_view.fonts[:sun_events];
            font_value.writeString(dc, dc.getWidth()/2, 0, compl.value.toString(), Graphics.TEXT_JUSTIFY_CENTER);
            var options = {
                :compl => compl, :font_label => font_label, 
                :font_value => font_value, :colors => colors};
            if (getId().equals("data_type_1")){
                drawField(options, Graphics.TEXT_JUSTIFY_RIGHT);
            }if (getId().equals("data_type_2")){
                drawField2(options);
            }if (getId().equals("data_type_3")){
                drawField(options, Graphics.TEXT_JUSTIFY_LEFT);
            }
        }
        drawBorder(dc);
    }

    function getComplLabel(compl){
        var res = compl.shortLabel;
        if (res == null){
            if (compl.unit instanceof Lang.String){
                res = compl.unit;
            }
        }
        return res;
    }

    function calculateLabelCoord1(){
        var dc = getDc();
        var pattern = getApp().watch_view.pattern;
        var diam = System.getDeviceSettings().screenHeight;
        var system_radius = diam / 2;
        label_radius = Math.floor((diam - Graphics.getFontHeight(font_label)) / 2 
            - pattern.reference_points[:pen_width]);

        var sin_angle = (system_radius - Global.mod(diam - pattern.reference_points[:y][5])) / system_radius;
        label_angle = 175 + Math.toDegrees(Math.asin(sin_angle));
        label_x = dc.getWidth() + (system_radius - getX() - dc.getWidth());
        label_y = -(label_radius - Global.mod(diam - getY()));
    }

    function calculateLabelCoord3(){
        var dc = getDc();
        var pattern = getApp().watch_view.pattern;
        var diam = System.getDeviceSettings().screenHeight;
        var system_radius = diam / 2;
        label_radius = Math.floor((diam - Graphics.getFontHeight(font_label)) / 2 
            - pattern.reference_points[:pen_width]);

        var sin_angle = (system_radius - Global.mod(diam - pattern.reference_points[:y][5])) / system_radius;
        label_angle = 360 - Math.toDegrees(Math.asin(sin_angle));
        label_x = -Global.mod(system_radius - getX());
        label_y = -(system_radius - Global.mod(diam - getY()));
    }

    function drawField(options, just){
        var dc = getDc();
        dc.setColor(options[:colors][:font], options[:colors][:background]);

        var label = getComplLabel(options[:compl]);
        if (label != null){
            dc.drawRadialText(
                label_x, 
                label_y, 
                font_label, label, 
                just, 
                label_angle, 
                label_radius, 
                Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE);
        }

    } 

    function drawField2(options){
        var dc = getDc();
        dc.setColor(options[:colors][:font], options[:colors][:background]);

        var label = getComplLabel(options[:compl]);
        if (label != null){
            dc.drawText(dc.getWidth() / 2, 
            dc.getHeight() - Graphics.getFontHeight(options[:font_label]), 
            options[:font_label], 
            options[:compl].shortLabel, 
            Graphics.TEXT_JUSTIFY_CENTER);
        }

    }    

    function getFieldComplication(){
        var compl = null;
        var compl_id = Application.Storage.getValue(getId());
		if (compl_id == null){
			compl_id = new Complications.Id(Application.Properties.getValue(getId()));
		}
		try {
			compl = Complications.getComplication(compl_id); 
		} catch(ex){
			System.println(compl_id);
			System.println(ex.getErrorMessage());
		}         
        return compl;
    }

}