import Toybox.Graphics;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Complications;
import Toybox.Lang;

class DataField extends AbstractField{

    function initialize(options){
        AbstractField.initialize(options);
    }

    function draw(colors){
        AbstractField.draw(colors);
        var dc = getDc();
        var compl = getFieldComplication();

        if (compl != null){
            
            var font_height = Math.round(System.getDeviceSettings().screenHeight * 0.07).toNumber();
            var font_label = Graphics.getVectorFont({
                :face => vectorFontName(),
                :size => font_height,
            });            
            var font_value = getApp().watch_view.fonts[:sun_events];

            font_value.writeString(dc, dc.getWidth()/2, 0, compl.value.toString(), Graphics.TEXT_JUSTIFY_CENTER);

            var options = {
                :compl => compl, :font_label => font_label, 
                :font_value => font_value, :colors => colors};

            if (getId().equals("data_type_1")){
                drawField1(options);
            }if (getId().equals("data_type_2")){
                drawField2(options);
            }if (getId().equals("data_type_3")){
                drawField3(options);
            }
        }
        drawBorder(dc);
    }

    function radialTextOffsets(font_label){
        
        var dc = getDc();
        var diam = System.getDeviceSettings().screenHeight;
        var system_radius = diam / 2;
        var radius = Math.floor((diam - Graphics.getFontHeight(font_label)) / 2);
        var pattern = getApp().watch_view.pattern;

        var sin_angle = (radius - Global.mod(diam - pattern.reference_points[:y][5])) / radius;
        var angle = Math.toDegrees(Math.asin(sin_angle));
        var offset_x = (system_radius - getX() - dc.getWidth());
        var offset_y = (radius - Global.mod(diam - getY()));

        return {:x => offset_x, :y => offset_y, :angle => angle, :radius => radius};
    }

    function drawField1(options){
        var dc = getDc();
        dc.setColor(options[:colors][:font], options[:colors][:background]);

        if (options[:compl].shortLabel != null){
            var offsets = radialTextOffsets(options[:font_label]);
            dc.drawRadialText(
                dc.getWidth() + offsets[:x], 
                0 - offsets[:y], 
                options[:font_label], options[:compl].shortLabel, 
                Graphics.TEXT_JUSTIFY_RIGHT, 
                175 + offsets[:angle], 
                offsets[:radius], 
                Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE);
        }

    } 

    function drawField2(options){
        var dc = getDc();
        dc.setColor(options[:colors][:font], options[:colors][:background]);

        if (options[:compl].shortLabel != null){ 
            dc.drawText(dc.getWidth() / 2, 
            dc.getHeight() - Graphics.getFontHeight(options[:font_label]), 
            options[:font_label], 
            options[:compl].shortLabel, 
            Graphics.TEXT_JUSTIFY_CENTER);
        }

    }    
    function drawField3(options){

        var dc = getDc();
        dc.setColor(options[:colors][:font], options[:colors][:background]);

        if (options[:compl].shortLabel != null){
            var offsets = radialTextOffsets(options[:font_label]);
            dc.drawRadialText(
                - offsets[:x], 
                0 - offsets[:y], 
                options[:font_label], options[:compl].shortLabel, 
                Graphics.TEXT_JUSTIFY_LEFT, 
                360 - offsets[:angle], 
                offsets[:radius], 
                Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE);
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